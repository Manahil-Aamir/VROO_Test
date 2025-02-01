import '../../../domain/entity/preference_entity.dart';

abstract class R2State {}

class PreferenceInitial extends R2State {}

class PreferenceSaving extends R2State {}

class PreferenceError extends R2State {
  final String error;

  PreferenceError(this.error);
}

class PreferenceSaved extends R2State {
  final PreferenceEntity savedPreference;

  PreferenceSaved(this.savedPreference);
}

class PreferenceLoading extends R2State {}

class PreferenceLoaded extends R2State {
  final PreferenceEntity loadedPreference;

  PreferenceLoaded(this.loadedPreference);
}

class PreferenceInputState extends R2State {
  final bool? sameGender;
  final bool? walk;

  PreferenceInputState({
    this.sameGender,
    this.walk,
  });

  PreferenceInputState copyWith({
    bool? sameGender,
    bool? walk,
  }) {
    return PreferenceInputState(
      sameGender: sameGender ?? this.sameGender,
      walk: walk ?? this.walk,
    );
  }
}
