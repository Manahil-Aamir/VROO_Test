import 'package:flutter/material.dart';
import '../../../cars/domain/entity/car.dart';
import '../../../../shared/domain/entity/location_entity.dart';

class ActiveRideEntity {
  final String id;
  final String rideId;
  final CarEntity car;
  final DateTime date;
  final TimeOfDay time;
  final TimeOfDay maxArrivalTime;
  // final int fare;
  final int totalSeats;
  final LocationEntity source;
  final LocationEntity destination;
  final List<PassengerEntity> passengers;
  final String status;

  ActiveRideEntity({
    required this.id,
    required this.rideId,
    required this.car,
    required this.date,
    required this.time,
    required this.maxArrivalTime,
    // required this.fare,
    required this.totalSeats,
    required this.source,
    required this.destination,
    required this.passengers,
    required this.status,
  });
}


class PassengerEntity {
  final int fare;
  final String rideRequestId;
  final String riderId;
  final String status;

  PassengerEntity({
    required this.fare,
    required this.rideRequestId,
    required this.riderId,
    required this.status,
  });
}
