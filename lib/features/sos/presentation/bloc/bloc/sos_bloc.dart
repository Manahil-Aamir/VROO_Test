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
      final success = await addEmergencyContact.call(event.contact, event.uid);
      if (success) {
        print('hello');
        add(FetchContacts(event.uid));
      } else {
        emit(SosError("Failed to add contact"));
      }
    } catch (e) {
      emit(SosError("Error adding contact"));
    }
  }

  Future<void> _onDeleteContact(
      DeleteContact event, Emitter<SosState> emit) async {
    try {
      final success =
          await deleteEmergencyContact.call(event.uid, event.contactId);
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
