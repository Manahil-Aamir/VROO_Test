import 'package:vroo_test/features/ride_start/data/models/address_model.dart';

import '../../domain/entities/riding_passenger_entity.dart';

class RidingPassengerModel extends RidingPassengerEntity {
  const RidingPassengerModel({
    super.review,
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
    final nullValues = <String>[];

    if (json['review'] == null) nullValues.add('review');
    if (json['riderId'] == null) nullValues.add('riderId');
    if (json['status'] == null) nullValues.add('status');
    if (json['rideRequestId'] == null) nullValues.add('rideRequestId');
    if (json['fare'] == null) nullValues.add('fare');
    if (json['eta'] == null) nullValues.add('eta');
    if (json['sameSource'] == null) nullValues.add('sameSource');
    if (json['sameDestination'] == null) nullValues.add('sameDestination');
    if (json['gender'] == null) nullValues.add('gender');
    if (json['detourDistance'] == null) nullValues.add('detourDistance');
    if (json['detourDuration'] == null) nullValues.add('detourDuration');
    if (json['username'] == null) nullValues.add('username');
    if (json['source'] == null) nullValues.add('source');
    if (json['destination'] == null) nullValues.add('destination');

    if (nullValues.isNotEmpty) {
      print('The following keys have null values: ${nullValues.join(', ')}');
    }

    return RidingPassengerModel(
      review: json['review'] != null ? json['review'].toString() : '',
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
      'review': review,
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
