import 'package:vroo_test/features/HomeScreens/domain/entity/ongoing_entity.dart';

class OngoingModel extends OngoingEntity {
  const OngoingModel({
    required super.role,
    required super.rideId,
  });

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'rideId': rideId,
    };
  }

  factory OngoingModel.fromMap(Map<String, dynamic> json) {
    return OngoingModel(
      role: json['role'] ?? '',
      rideId: json['rideId'] ?? '',
    );
  }
}
