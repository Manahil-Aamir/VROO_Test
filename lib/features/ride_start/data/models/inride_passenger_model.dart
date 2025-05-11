import '../../domain/entities/inride_passenger_entity.dart';

import 'package:vroo_test/features/ride_start/data/models/rider_model.dart';
import 'package:vroo_test/features/ride_start/domain/entities/rider_entity.dart';

class InridePassengerModel extends InridePassengerEntity {
  InridePassengerModel({
    required super.riderId,
    required super.status,
    required super.fare,
    required super.rideRequestId,
    required super.eta,
    required super.rideRequest,
    required super.riderName,
    super.review,
    super.sameSource,
    super.sameDestination,
    super.fcmToken,
    super.detourDistance,
    super.detourDuration,
  });

  // Convert model to map
  Map<String, dynamic> toMap() {
    return {
      'riderId': riderId,
      'status': status,
      'fare': fare,
      'rideRequestId': rideRequestId,
      'eta': eta?.toIso8601String(),
      'rideRequest': (rideRequest as RiderModel).toMap(),
      'riderName': riderName,
      'review': review ?? '',
      'sameSource': sameSource ?? false,
      'sameDestination': sameDestination ?? false,
      'fcmToken': fcmToken ?? '',
      'detourDistance': detourDistance ?? 0.0,
      'detourDuration': detourDuration ?? 0.0,
    };
  }

  // Create model from map
  factory InridePassengerModel.fromMap(Map<String, dynamic> map) {
    return InridePassengerModel(
      riderId: map['riderId'] ?? '',
      status: map['status'] ?? '',
      fare: (map['fare'] as num?)?.toDouble() ?? 0.0,
      rideRequestId: map['rideRequestId'] ?? '',
      eta: map['eta'] != null ? DateTime.tryParse(map['eta']) : null,
      rideRequest: RiderModel.fromMap(map['rideRequest']),
      riderName: map['riderName'] ?? '',
      review: map['review'],
      sameSource: map['sameSource'],
      sameDestination: map['sameDestination'],
      fcmToken: map['fcmToken'],
      detourDistance: (map['detourDistance'] as num?)?.toDouble(),
      detourDuration: (map['detourDuration'] as num?)?.toDouble(),
    );
  }
}
