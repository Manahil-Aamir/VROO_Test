import '../../data/models/contact_model.dart';

abstract class SosRepository {
  Future<Map<String, dynamic>> addEmergencyContact(
      ContactModel contact, String token);
  Future<List<ContactModel>> getEmergencyContacts(String token);
  Future<bool> deleteEmergencyContact(String contactId, String token);
  Future<String> triggerSOS(String token);
}
