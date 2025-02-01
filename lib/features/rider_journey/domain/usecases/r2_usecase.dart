import 'package:vroo_test/features/rider_journey/data/model/preferences_model.dart';

import '../repository/r2_repository.dart';

class SavePreferenceUseCase {
  final R2Repository repository;

  SavePreferenceUseCase(this.repository);

  Future<void> execute(PreferencesModel preference) {
    return repository.savePreference(preference.toMap());
  }
}

class LoadPreferenceUseCase {
  final R2Repository repository;

  LoadPreferenceUseCase(this.repository);

  Future<PreferencesModel?> execute() async {
    final preferenceData = await repository.loadPreference();
    if (preferenceData != null) {
      return PreferencesModel.fromMap(preferenceData);
    }
    return null;
  }
}
