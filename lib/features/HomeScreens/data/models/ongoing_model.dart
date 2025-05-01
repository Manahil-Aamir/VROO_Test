import 'package:vroo_test/features/HomeScreens/domain/entity/ongoing_entity.dart';

class OngoingModel extends OngoingEntity {
  const OngoingModel({
    required super.mode,
    required super.rideId,
  });

  Map<String, dynamic> toMap() {
    return {
      'mode': mode,
      'rideId': rideId,
    };
  }

  factory OngoingModel.fromMap(Map<String, dynamic> json) {
    return OngoingModel(
      mode: json['mode'] ?? '',
      rideId: json['rideId'] ?? '',
    );
  }
}
