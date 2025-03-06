import '../../data/models/contact_model.dart';

abstract class SosRepository {
  Future<List<ContactModel>> getContacts();
  Future<void> saveContacts(List<ContactModel> contacts);
}
