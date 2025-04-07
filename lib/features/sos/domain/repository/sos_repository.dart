import '../../data/models/contact_model.dart';

abstract class SosRepository {
  Future<Map<String, dynamic>> addEmergencyContact(
      ContactModel contact, String uid, String token);
  Future<List<ContactModel>> getEmergencyContacts(String uid, String token);
  Future<bool> deleteEmergencyContact(
      String uid, String contactId, String token);
  Future<String> triggerSOS(String uid, String token);
}
