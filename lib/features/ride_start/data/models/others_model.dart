import 'package:vroo_test/features/ride_start/domain/entities/others_entity.dart';

class OthersModel extends OthersEntity {
  const OthersModel({
    required super.riderId,
    required super.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'riderId': riderId,
      'name': name,
    };
  }

  factory OthersModel.fromMap(Map<String, dynamic> json) {
    return OthersModel(
      riderId: json['riderId'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
