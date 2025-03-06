import 'package:vroo_test/features/sos/data/models/contact_model.dart';

abstract class SosEvent {}

class LoadContacts extends SosEvent {}

class SaveContacts extends SosEvent {
  final List<ContactModel> contacts;
  SaveContacts(this.contacts);
}

class RequestPermissions extends SosEvent {}

class SendSos extends SosEvent {}

class PickContact extends SosEvent {}
