import '../../domain/entity/preferences.dart';

class PreferencesModel {
  final bool canWalk;
  final bool femaleOnly;
  final bool maleOnly;

  PreferencesModel({
    required this.canWalk,
    required this.femaleOnly,
    required this.maleOnly,
  });

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      canWalk: json['canWalk'] ?? false,
      femaleOnly: json['femaleOnly'] ?? false,
      maleOnly: json['maleOnly'] ?? false,
    );
  }

  Preferences toEntity() => Preferences(
        canWalk: canWalk,
        femaleOnly: femaleOnly,
        maleOnly: maleOnly,
      );
}
