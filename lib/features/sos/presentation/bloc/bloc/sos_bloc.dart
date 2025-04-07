import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/features/sos/data/models/contact_model.dart';
import '../../../../authentication/domain/usecases/get_token_usecase.dart';
import '../../../domain/usecases/delete_contact_usecase.dart';
import '../../../domain/usecases/get_contacts_usecase.dart';
import '../../../domain/usecases/save_contacts_usecase.dart';
import '../../../domain/usecases/trigger_sos_usecase.dart';
import '../event/sos_event.dart';
import '../state/sos_state.dart';

class SosBloc extends Bloc<SosEvent, SosState> {
  final GetEmergencyContacts getEmergencyContacts;
  final AddEmergencyContact addEmergencyContact;
  final DeleteEmergencyContact deleteEmergencyContact;
  final TriggerSOS triggerSOS;
  final GetTokenUseCase getTokenUsecase;

  SosBloc({
    required this.getEmergencyContacts,
    required this.addEmergencyContact,
    required this.deleteEmergencyContact,
    required this.triggerSOS,
    required this.getTokenUsecase,
  }) : super(SosInitial()) {
    on<FetchContacts>(_onFetchContacts);
    on<AddContact>(_onAddContact);
    on<DeleteContact>(_onDeleteContact);
    on<TriggerSos>(_onTriggerSos);
  }

  Future<void> _onFetchContacts(
      FetchContacts event, Emitter<SosState> emit) async {
    emit(SosLoading());
    try {
      print('Fetching contacts...');
      final token = await getTokenUsecase.call();
      print('Token: $token');

      if (token == null) {
        emit(SosError("Failed to fetch contacts: Token is null"));
        return;
      }

      final contacts = await getEmergencyContacts.call(event.uid, token);
      final contactsString =
          contacts.map((contact) => contact.toString()).join(', ');
      print('Contacts: $contactsString');
      emit(SosLoaded(contacts));
    } catch (e) {
      emit(SosError("Failed to fetch contacts"));
    }
  }

  Future<void> _onAddContact(AddContact event, Emitter<SosState> emit) async {
    try {
      final token = await getTokenUsecase.call();

      if (token == null) {
        emit(SosError("Failed to add contact: Token is null"));
        return;
      }

      final result =
          await addEmergencyContact.call(event.contact, event.uid, token);

      if (result['success'] == true) {
        add(FetchContacts(event.uid));
      } else {
        print('Failed to add contact');
        String errorMessage = result['error'] != null &&
                result['error']!.contains('emergencyContacts')
            ? "A user can have up to 5 emergency contacts."
            : result['error'] ?? result['message'] ?? "Failed to add contact";

        final List<ContactModel> previousContacts = (state is SosLoaded)
            ? List<ContactModel>.from((state as SosLoaded).contacts)
            : [];

        emit(SosError(errorMessage, previousContacts));
      }
    } catch (e) {
      final List<ContactModel> previousContacts = (state is SosLoaded)
          ? (state as SosLoaded)
              .contacts
              .map((contact) => ContactModel.fromMap(contact.toMap()))
              .toList()
          : [];

      emit(SosError("Error adding contact: ${e.toString()}", previousContacts));
    }
  }

  Future<void> _onDeleteContact(
      DeleteContact event, Emitter<SosState> emit) async {
    try {
      final token = await getTokenUsecase.call();
      print(token);

      if (token == null) {
        emit(SosError("Failed to delete contact: Token is null"));
        return;
      }

      final success =
          await deleteEmergencyContact.call(event.uid, event.contactId, token);
      print('Contact Id: ${event.contactId}');
      if (success) {
        add(FetchContacts(event.uid));
      } else {
        emit(SosError("Failed to delete contact"));
      }
    } catch (e) {
      emit(SosError("Error deleting contact"));
    }
  }

  Future<void> _onTriggerSos(TriggerSos event, Emitter<SosState> emit) async {
    emit(SosLoading());
    try {
      final token = await getTokenUsecase.call();

      if (token == null) {
        emit(SosError("Failed to trigger SOS: Token is null"));
        return;
      }

      final String message = await triggerSOS.call(event.uid, token);

      if (message.startsWith("Message sent successfully")) {
        final sessionId = message.split('(').last.replaceAll(')', '').trim();
        emit(SosTriggered(message, sessionId));
      } else {
        emit(SosError(message));
      }
    } catch (e) {
      emit(SosError("Failed to trigger SOS: ${e.toString()}"));
    }
  }
}
