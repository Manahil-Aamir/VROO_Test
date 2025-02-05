import 'package:flutter/material.dart';
import '../../../driver_booking/domain/entity/car.dart';

class ActiveRideEntity {
  final String id;
  final String rideId;
  final CarEntity car;
  final DateTime date;
  final TimeOfDay time;
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
    // required this.fare,
    required this.totalSeats,
    required this.source,
    required this.destination,
    required this.passengers,
    required this.status,
  });
}

class LocationEntity {
  final String address;
  final String cellId;
  final List<double> coords;
  final String placeId;

  LocationEntity({
    required this.address,
    required this.cellId,
    required this.coords,
    required this.placeId,
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
