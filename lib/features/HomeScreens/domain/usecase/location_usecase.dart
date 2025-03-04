import '../entity/prediction.dart';
import '../repository/location_repository.dart';

class SaveLocationUseCase {
  final LocationRepository repository;

  SaveLocationUseCase(this.repository);

  Future<void> execute(Prediction prediction, String role) {
    return repository.saveSelectedLocation(prediction, role);
  }
}

class GetLocationUseCase {
  final LocationRepository repository;

  GetLocationUseCase(this.repository);

  Future<Prediction?> execute(String role) {
    return repository.getSelectedLocation(role);
  }
}