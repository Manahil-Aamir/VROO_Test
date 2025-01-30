import '../entity/driver_schedule2_entity.dart';
import '../repository/driver_schedule2_repository.dart';

class SaveCarPreferencesUseCase {
  final D2Repository repository;

  SaveCarPreferencesUseCase(this.repository);

  Future<void> execute(CarPreferencesEntity preferences) =>
      repository.saveCarPreferences(preferences.toMap());
}

class LoadCarPreferencesUseCase {
  final D2Repository repository;

  LoadCarPreferencesUseCase(this.repository);

  Future<CarPreferencesEntity?> execute() async {
    final data = await repository.loadCarPreferences();
    return data != null ? CarPreferencesEntity.fromMap(data) : null;
  }
}
