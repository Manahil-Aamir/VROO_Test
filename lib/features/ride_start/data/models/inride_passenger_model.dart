import '../../domain/entities/inride_passenger_entity.dart';

import 'package:vroo_test/features/ride_start/data/models/rider_model.dart';
import 'package:vroo_test/features/ride_start/domain/entities/rider_entity.dart';

class InridePassengerModel extends InridePassengerEntity {
  InridePassengerModel({
    required super.riderId,
    required super.status,
    required super.fare,
    required super.rideRequestId,
    super.review,
    required super.id,
    required super.rideRequest,
    required super.riderName,
  });

  // Convert model to map
  @override
  Map<String, dynamic> toMap() {
    return {
      'riderId': riderId,
      'status': status,
      'fare': fare,
      'rideRequestId': rideRequestId,
      'review': review,
      '_id': id,
      'rideRequest': rideRequest.toMap(),
      'riderName': riderName,
    };
  }

  // Create model from map
  factory InridePassengerModel.fromMap(Map<String, dynamic> map) {
    return InridePassengerModel(
      riderId: map['riderId'] ?? '',
      status: map['status'] ?? '',
      fare: (map['fare'] as num).toDouble(),
      rideRequestId: map['rideRequestId'] ?? '',
      review: map['review'],
      id: map['_id'] ?? '',
      rideRequest: RiderModel.fromMap(map['rideRequest']),
      riderName: map['riderName'] ?? '',
    );
  }

  // Convert entity to model
  factory InridePassengerModel.fromEntity(InridePassengerEntity entity) {
    return InridePassengerModel(
      riderId: entity.riderId,
      status: entity.status,
      fare: entity.fare,
      rideRequestId: entity.rideRequestId,
      review: entity.review,
      id: entity.id,
      rideRequest: entity.rideRequest,
      riderName: entity.riderName,
    );
  }
}