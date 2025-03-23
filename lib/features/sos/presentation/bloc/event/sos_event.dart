import 'package:equatable/equatable.dart';
import 'package:vroo_test/features/sos/data/models/contact_model.dart';

abstract class SosEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Fetch all contacts
class FetchContacts extends SosEvent {
  final String uid;

  FetchContacts(this.uid);

  @override
  List<Object> get props => [uid];
}

// Add a new contact
class AddContact extends SosEvent {
  final ContactModel contact;
  final String uid;

  AddContact(this.contact, this.uid);

  @override
  List<Object> get props => [contact, uid];
}

// Delete a contact
class DeleteContact extends SosEvent {
  final String uid;
  final String contactId;

  DeleteContact(this.uid, this.contactId);

  @override
  List<Object> get props => [uid, contactId];
}

// Trigger SOS event
class TriggerSos extends SosEvent {
  final String uid;

  TriggerSos(this.uid);

  @override
  List<Object> get props => [uid];
}
