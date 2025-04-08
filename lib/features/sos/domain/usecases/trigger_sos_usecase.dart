import '../repository/sos_repository.dart';

class TriggerSOS {
  final SosRepository repository;

  TriggerSOS(this.repository);

  Future<String> call(String token) {
    return repository.triggerSOS(token);
  }
}
