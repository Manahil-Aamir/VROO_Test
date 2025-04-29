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
  });

  // Convert model to map
  Map<String, dynamic> toMap() {
    return {
      'riderId': riderId,
      'status': status,
      'fare': fare,
      'rideRequestId': rideRequestId,
      'eta': eta,
      'rideRequest': rideRequest.toMap(),
      'riderName': riderName,
      'review': review ?? '',
      'sameSource': sameSource ?? false,
      'sameDestination': sameDestination ?? false,
      'fcmToken': fcmToken ?? '',
    };
  }

  // Create model from map
  factory InridePassengerModel.fromMap(Map<String, dynamic> map) {
    return InridePassengerModel(
      riderId: map['riderId'] ?? '',
      status: map['status'] ?? '',
      fare: (map['fare'] != null ? (map['fare'] as num).toDouble() : 0.0),
      rideRequestId: map['rideRequestId'] ?? '',
      eta: DateTime.parse(map['eta']), //map['eta'],
      rideRequest: RiderModel.fromMap(map['rideRequest']),
      riderName: map['riderName'] ?? '',
    );
  }
}
