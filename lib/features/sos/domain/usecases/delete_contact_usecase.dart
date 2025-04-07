import '../repository/sos_repository.dart';

class DeleteEmergencyContact {
  final SosRepository repository;

  DeleteEmergencyContact(this.repository);

  Future<bool> call(String uid, String contactId, String token) {
    return repository.deleteEmergencyContact(uid, contactId, token);
  }
}
