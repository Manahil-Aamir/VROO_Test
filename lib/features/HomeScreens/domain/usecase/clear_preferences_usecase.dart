import '../repository/home_repository.dart';

class ClearPreferencesUseCase {
  final HomeRepository repository;

  ClearPreferencesUseCase(this.repository);

  Future<void> execute() => repository.clearSharedPreferences();
}
