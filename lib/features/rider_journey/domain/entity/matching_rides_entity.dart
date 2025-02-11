import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vroo_test/features/rider_journey/data/model/matching_rides_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/ride_journey_model.dart';

class MatchingRide extends Equatable {
  final String id;
  final CarDetailsModel car;
  final String date;
  final String departureTime;
  final RideLocationModel source;
  final RideLocationModel destination;
  final int distance;
  final String driverId;
  final int duration;
  final EnvironmentStatsModel environmentStats;
  final String expectedArrivalTime;
  final int fare;
  final bool isRecurring;
  final String maxArrivalTime;
  final List<String> neighbourRouteCells;
  final int numOfSeats;
  final List<PassengerModel> passengers;
  final List<dynamic> paymentMethod;
  final RidePreferencesModel preferences;
  final List<dynamic> recurringRides;
  final List<dynamic> routeCells;
  final List<dynamic> routeCoords;
  final String status;
  final double totalDetourDistance;
  final double totalDetourDuration;

  const MatchingRide({
    required this.id,
    required this.car,
    required this.date,
    required this.departureTime,
    required this.source,
    required this.destination,
    required this.distance,
    required this.driverId,
    required this.duration,
    required this.environmentStats,
    required this.expectedArrivalTime,
    required this.fare,
    required this.isRecurring,
    required this.maxArrivalTime,
    required this.neighbourRouteCells,
    required this.numOfSeats,
    required this.passengers,
    required this.paymentMethod,
    required this.preferences,
    required this.recurringRides,
    required this.routeCells,
    required this.routeCoords,
    required this.status,
    required this.totalDetourDistance,
    required this.totalDetourDuration,
  });

  @override
  List<Object> get props => [
        id,
        car,
        date,
        departureTime,
        source,
        destination,
        distance,
        driverId,
        duration,
        environmentStats,
        expectedArrivalTime,
        fare,
        isRecurring,
        maxArrivalTime,
        neighbourRouteCells,
        numOfSeats,
        passengers,
        paymentMethod,
        preferences,
        recurringRides,
        routeCells,
        routeCoords,
        status,
        totalDetourDistance,
        totalDetourDuration,
      ];
}

class CarDetails extends Equatable {
  final String color;
  final String company;
  final bool isVerified;
  final double mileage;
  final String model;
  final String numberPlate;

  const CarDetails({
    required this.color,
    required this.company,
    required this.isVerified,
    required this.mileage,
    required this.model,
    required this.numberPlate,
  });

  @override
  List<Object> get props =>
      [color, company, isVerified, mileage, model, numberPlate];
}

class EnvironmentStats extends Equatable {
  final double co2Saved;
  final int fuelSaved;

  const EnvironmentStats({required this.co2Saved, required this.fuelSaved});

  @override
  List<Object> get props => [co2Saved, fuelSaved];
}

class Passenger extends Equatable {
  final String eta;
  final int fare;
  final String rideRequestId;
  final String riderId;
  final String status;

  const Passenger({
    required this.eta,
    required this.fare,
    required this.rideRequestId,
    required this.riderId,
    required this.status,
  });

  @override
  List<Object> get props => [eta, fare, rideRequestId, riderId, status];
}

class RideResponse extends Equatable {
  final String message;
  final String rideRequestId;
  final List<MatchingRideModel> matchingRides;

  const RideResponse({
    required this.message,
    required this.rideRequestId,
    required this.matchingRides,
  });

  @override
  List<Object> get props => [message, rideRequestId, matchingRides];
}
