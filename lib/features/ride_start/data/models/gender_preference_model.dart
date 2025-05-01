import 'package:vroo_test/features/ride_start/domain/entities/gender_preference_entity.dart';

class GenderPreferencesModel extends GenderPreferencesEntity {
  const GenderPreferencesModel({
    required super.id,
    required super.maleOnly,
    required super.femaleOnly,
  });

  factory GenderPreferencesModel.fromMap(Map<String, dynamic> json) {
    return GenderPreferencesModel(
      id: json['_id'] ?? '',
      maleOnly: json['maleOnly'] ?? false,
      femaleOnly: json['femaleOnly'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'maleOnly': maleOnly,
      'femaleOnly': femaleOnly,
    };
  }
}
