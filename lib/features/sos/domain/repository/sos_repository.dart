import '../../data/models/contact_model.dart';

abstract class SosRepository {
  Future<bool> addEmergencyContact(ContactModel contact, String uid);
  Future<List<ContactModel>> getEmergencyContacts(String uid);
  Future<bool> deleteEmergencyContact(String uid, String contactId);
  Future<void> triggerSOS(String uid);
}
