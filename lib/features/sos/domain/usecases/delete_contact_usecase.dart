import '../repository/sos_repository.dart';

class DeleteEmergencyContact {
  final SosRepository repository;

  DeleteEmergencyContact(this.repository);

  Future<bool> call(String contactId, String token) {
    return repository.deleteEmergencyContact(contactId, token);
  }
}
