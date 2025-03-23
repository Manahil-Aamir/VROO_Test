import '../../data/models/contact_model.dart';
import '../repository/sos_repository.dart';

class AddEmergencyContact {
  final SosRepository repository;

  AddEmergencyContact(this.repository);

  Future<bool> call(ContactModel contact, String uid) {
    return repository.addEmergencyContact(contact, uid);
  }
}
