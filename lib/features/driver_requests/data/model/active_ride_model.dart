import 'package:flutter/material.dart';

import '../../domain/entity/active_ride.dart';
import '../../../cars/data/model/carr_model.dart';

class ActiveRideModel {
  final String id;
  final String rideId;  
  final Car car;
  final DateTime date;
  final TimeOfDay time;
  final TimeOfDay maxArrivalTime;
  // final int fare;
  final int totalSeats;
  final LocationModel source;
  final LocationModel destination;
  final List<PassengerModel> passengers;
  final String status;

  ActiveRideModel({
    required this.id,
    required this.rideId,
    required this.car,
    required this.date,
    required this.time,
    // required this.fare,
    required this.maxArrivalTime,
    required this.totalSeats,
    required this.source,
    required this.destination,
    required this.passengers,
    required this.status,
  });

  factory ActiveRideModel.fromJson(Map<String, dynamic> json) {
  return ActiveRideModel(
    id: json['_id'] ?? '', // Handle null ID
    rideId: json['rideId'] ?? '', // Handle null rideId
    car: Car.fromJson(json['car'] ?? {}), // Handle null car
    date: DateTime.parse(json['date']),
    time: TimeOfDay.fromDateTime(DateTime.parse(json['departureTime'])),
    // fare: json['fare']?.toInt() ?? 0,
    maxArrivalTime: TimeOfDay.fromDateTime(DateTime.parse(json['maxArrivalTime'])),
    totalSeats: json['numOfSeats']?.toInt() ?? 0,
    source: LocationModel.fromJson(json['source'] ?? {}),
    destination: LocationModel.fromJson(json['destination'] ?? {}),
    passengers: List<PassengerModel>.from(
      (json['passengers'] ?? []).map((x) => PassengerModel.fromJson(x))
    ),
    status: json['status'] ?? 'unknown', // Handle null status
  );
}

  ActiveRideEntity toEntity() => ActiveRideEntity(
        id: id,
        rideId: rideId,
        car: car.toEntity(),
        date: date,
        time: time,
        // fare: fare,
        maxArrivalTime: maxArrivalTime,
        totalSeats: totalSeats,
        source: source.toEntity(),
        destination: destination.toEntity(),
        passengers: passengers.map((p) => p.toEntity()).toList(),
        status: status,
      );
}

class LocationModel {
  final String address;
  final String cellId;
  final List<double> coords;
  final String placeId;

  LocationModel({
    required this.address,
    required this.cellId,
    required this.coords,
    required this.placeId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
  return LocationModel(
    address: json['address'] ?? 'Unknown address',
    cellId: json['cellId'] ?? '',
    coords: List<double>.from((json['coords'] ?? []).map((x) => x.toDouble())),
    placeId: json['placeId'] ?? '',
  );
}

  LocationEntity toEntity() => LocationEntity(
        address: address,
        cellId: cellId,
        coords: coords,
        placeId: placeId,
      );
}

class PassengerModel {
  final int fare;
  final String rideRequestId;
  final String riderId;
  final String status;

  PassengerModel({
    required this.fare,
    required this.rideRequestId,
    required this.riderId,
    required this.status,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      fare: json['fare']?.toInt() ?? 0,
      rideRequestId: json['rideRequestId'] ?? '',
      riderId: json['riderId'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }

  PassengerEntity toEntity() => PassengerEntity(
        fare: fare,
        rideRequestId: rideRequestId,
        riderId: riderId,
        status: status,
      );
}
