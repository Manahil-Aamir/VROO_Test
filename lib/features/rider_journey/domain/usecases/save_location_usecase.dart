import '../entity/prediction_entity.dart';
import '../repository/location_repository.dart';

class SaveSelectedLocationUseCase {
  final LocationRepository repository;

  SaveSelectedLocationUseCase(this.repository);

  Future<void> execute(Location prediction) {
    return repository.saveSelectedLocation(prediction);
  }
}

class GetSelectedLocationUseCase {
  final LocationRepository repository;

  GetSelectedLocationUseCase(this.repository);

  Future<Location?> execute() {
    return repository.getSelectedLocation();
  }
}
