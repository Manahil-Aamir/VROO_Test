import '../../data/models/contact_model.dart';
import '../repository/sos_repository.dart';

class AddEmergencyContact {
  final SosRepository repository;

  AddEmergencyContact(this.repository);

  Future<Map<String, dynamic>> call(ContactModel contact, String token) {
    return repository.addEmergencyContact(contact, token);
  }
}
