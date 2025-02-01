import 'package:vroo_test/features/rider_journey/domain/entity/preference_entity.dart';

class PreferencesModel extends PreferenceEntity {
  PreferencesModel({
    required super.sameGender,
    required super.walk,
  });

  Map<String, dynamic> toMap() {
    return {
      'sameGender': sameGender,
      'walk': walk,
    };
  }

  factory PreferencesModel.fromMap(Map<String, dynamic> map) {
    return PreferencesModel(
      sameGender: map['sameGender'],
      walk: map['walk'],
    );
  }
}
