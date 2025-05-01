import 'package:vroo_test/features/ride_start/domain/entities/ride_start_entity.dart';

import 'ridestart_data_model.dart';

class RideStartModel extends RideStartEntity {
  RideStartModel({
    required super.success,
    required super.message,
    required super.data,
  });

  // Convert model to map
  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data.toMap(),
    };
  }

  // Create model from map
  factory RideStartModel.fromMap(Map<String, dynamic> map) {
    return RideStartModel(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      data: RidestartDataModel.fromMap(map['data']),
    );
  }
}
