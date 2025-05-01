import 'package:vroo_test/features/ride_start/data/models/address_model.dart';

import '../../domain/entities/riding_passenger_entity.dart';

class RidingPassengerModel extends RidingPassengerEntity {
  const RidingPassengerModel({
    super.riderId,
    required super.status,
    required super.rideRequestId,
    required super.fare,
    required super.eta,
    required super.sameSource,
    required super.sameDestination,
    required super.gender,
    required super.detourDistance,
    required super.detourDuration,
    required super.username,
    required super.source,
    required super.destination,
  });

  factory RidingPassengerModel.fromMap(Map<String, dynamic> json) {
    return RidingPassengerModel(
      riderId: json['riderId'],
      status: json['status'] ?? '',
      rideRequestId: json['rideRequestId'] ?? '',
      fare: (json['fare'] as num?)?.toDouble() ?? 0.0,
      eta: DateTime.parse(json['eta'] ?? DateTime.now().toIso8601String()),
      sameSource: json['sameSource'] ?? false,
      sameDestination: json['sameDestination'] ?? false,
      gender: json['gender'] ?? '',
      detourDistance: json['detourDistance'] ?? 0,
      detourDuration: json['detourDuration'] ?? 0,
      username: json['username'] ?? '',
      source: AddressModel.fromMap(json['source']),
      destination: AddressModel.fromMap(json['destination']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'riderId': riderId,
      'status': status,
      'rideRequestId': rideRequestId,
      'fare': fare,
      'eta': eta.toIso8601String(),
      'sameSource': sameSource,
      'sameDestination': sameDestination,
      'gender': gender,
      'detourDistance': detourDistance,
      'detourDuration': detourDuration,
      'username': username,
      'source': source,
      'destination': destination,
    };
  }
}
