import 'package:shared_preferences/shared_preferences.dart';
import 'package:vroo_test/features/rider_journey/domain/repository/rider_home_domain_repository.dart';

class ClearPreferencesUseCase {
  final RiderHomeRepository repository;

  ClearPreferencesUseCase(this.repository);

  Future<void> execute() async {
    return repository.clearSharedPreferences();
  }
}
