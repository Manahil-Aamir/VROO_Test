import '../repository/sos_repository.dart';

class TriggerSOS {
  final SosRepository repository;

  TriggerSOS(this.repository);

  Future<String> call(String uid, String token) {
    return repository.triggerSOS(uid, token);
  }
}
