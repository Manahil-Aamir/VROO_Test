import 'package:equatable/equatable.dart';
import 'package:vroo_test/features/sos/data/models/contact_model.dart';

abstract class SosEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Fetch all contacts
class FetchContacts extends SosEvent {}

// Add a new contact
class AddContact extends SosEvent {
  final ContactModel contact;

  AddContact(this.contact);

  @override
  List<Object> get props => [contact];
}

// Delete a contact
class DeleteContact extends SosEvent {
  final String contactId;

  DeleteContact(this.contactId);

  @override
  List<Object> get props => [contactId];
}

// Trigger SOS event
class TriggerSos extends SosEvent {}
