// ride_entity.dart
import 'package:equatable/equatable.dart';
import 'package:vroo_test/features/ride_start/domain/entities/gender_preference_entity.dart';
import 'package:vroo_test/features/ride_start/domain/entities/riding_passenger_entity.dart';

import 'address_entity.dart';

class RideViewEntity extends Equatable {
  final String id;
  final String driverId;
  final String driverName;
  final String driverGender;
  final int numOfSeats;
  final DateTime date;
  final Address source;
  final Address destination;
  final DateTime departureTime;
  final DateTime maxArrivalTime;
  final int distance;
  final int duration;
  final int totalDetourDistance;
  final int totalDetourDuration;
  final List<String> routeCells;
  final List<String> neighbourRouteCells;
  final GenderPreferencesEntity preferences;
  final bool isRecurring;
  final List<dynamic> recurringRides;
  final List<String> paymentMethod;
  final double fare;
  final String status;
  final DateTime expectedArrivalTime;
  final List<List<double>> routeCoords;
  final RidingPassengerEntity? passengerData;
  final List<Map<String, dynamic>> otherPassengers;

  const RideViewEntity({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.driverGender,
    required this.numOfSeats,
    required this.date,
    required this.source,
    required this.destination,
    required this.departureTime,
    required this.maxArrivalTime,
    required this.distance,
    required this.duration,
    required this.totalDetourDistance,
    required this.totalDetourDuration,
    required this.routeCells,
    required this.neighbourRouteCells,
    required this.preferences,
    required this.isRecurring,
    required this.recurringRides,
    required this.paymentMethod,
    required this.fare,
    required this.status,
    required this.expectedArrivalTime,
    required this.routeCoords,
    this.passengerData,
    required this.otherPassengers,
  });

  @override
  List<Object?> get props => [
        id,
        driverId,
        driverName,
        driverGender,
        numOfSeats,
        date,
        source,
        destination,
        departureTime,
        maxArrivalTime,
        distance,
        duration,
        totalDetourDistance,
        totalDetourDuration,
        routeCells,
        neighbourRouteCells,
        preferences,
        isRecurring,
        recurringRides,
        paymentMethod,
        fare,
        status,
        expectedArrivalTime,
        routeCoords,
        passengerData,
        otherPassengers,
      ];
}
