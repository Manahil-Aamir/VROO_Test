import '../entity/prediction.dart';
import '../repository/location_repository.dart';

class SaveSelectedLocationUseCase {
  final LocationRepository repository;

  SaveSelectedLocationUseCase(this.repository);

  Future<void> execute(Prediction prediction) {
    return repository.saveSelectedLocation(prediction);
  }
}

class GetSelectedLocationUseCase {
  final LocationRepository repository;

  GetSelectedLocationUseCase(this.repository);

  Future<Prediction?> execute() {
    return repository.getSelectedLocation();
  }
}