import 'package:vroo_test/features/rider_journey/domain/entity/preference_entity.dart';

class PreferencesModel extends PreferenceEntity {
  PreferencesModel({
    required super.sameGender,
    // required super.maleOnly,
    // required super.femaleOnly,
    required super.walk,
  });

  Map<String, dynamic> toMap() {
    return {
      'sameGender': sameGender,
      // 'maleOnly': maleOnly,
      // 'femaleOnly': femaleOnly,
      'walk': walk,
    };
  }

  factory PreferencesModel.fromMap(Map<String, dynamic> map) {
    return PreferencesModel(
      sameGender: map['sameGender'],
      // maleOnly: map['maleOnly'] ?? false,
      // femaleOnly: map['femaleOnly'] ?? false,
      walk: map['walk'] ?? false,
    );
  }
}
