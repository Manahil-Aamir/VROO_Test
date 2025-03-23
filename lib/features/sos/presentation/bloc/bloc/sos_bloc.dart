import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/features/sos/data/models/contact_model.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../../../../core/services/permission_handler.dart';
import '../../../../../core/services/sms_service.dart';
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

  SosBloc({
    required this.getEmergencyContacts,
    required this.addEmergencyContact,
    required this.deleteEmergencyContact,
    required this.triggerSOS,
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
      print('fetching contacts');
      final contacts = await getEmergencyContacts.call(event.uid);
      // Log the fetched contacts
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
      final result = await addEmergencyContact.call(event.contact, event.uid);

      if (result['success'] == true) {
        add(FetchContacts(event.uid));
      } else if (result['success'] == false) {
        print('success is false');
        String errorMessage = result['error'] != null &&
                result['error']!.contains('emergencyContacts')
            ? "A user can have up to 5 emergency contacts."
            : result['error'] ?? result['message'] ?? "Failed to add contact";
        print('errorMessage: $errorMessage');
        // Deep copy to prevent mutation issues
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
      final success =
          await deleteEmergencyContact.call(event.uid, event.contactId);
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
      final sosLink = await triggerSOS.call(event.uid);
      emit(SosTriggered(''));
    } catch (e) {
      emit(SosError("Failed to trigger SOS"));
    }
  }
}
