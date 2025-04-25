import 'package:vroo_test/features/ride_start/data/models/inride_passenger_model.dart';
import 'package:vroo_test/features/ride_start/domain/entities/ridestart_data_entity.dart';

import '../../../driver_requests/data/model/active_ride_model.dart';
import '../../../rider_journey/data/model/matching_rides_model.dart';
import '../../../rider_journey/data/model/ride_journey_model.dart';
import 'address_model.dart';

class RidestartDataModel extends RidestartDataEntity {
  RidestartDataModel({
    required super.id,
    required super.driverId,
    required super.numOfSeats,
    required super.date,
    required super.source,
    required super.destination,
    required super.departureTime,
    required super.maxArrivalTime,
    required super.distance,
    required super.duration,
    required super.preferences,
    required super.isRecurring,
    required super.car,
    required super.recurringRides,
    required super.paymentMethod,
    required super.fare,
    required super.status,
    required super.environmentStats,
    required super.expectedArrivalTime,
    required super.routeCoords,
    required super.passengers,
  });

  factory RidestartDataModel.fromMap(Map<String, dynamic> map) {
    return RidestartDataModel(
      id: map['_id'],
      driverId: map['driverId'],
      numOfSeats: map['numOfSeats'].toDouble(),
      date: DateTime.parse(map['date']), //['date'],
      source: AddressModel.fromMap(map['source']),
      destination: AddressModel.fromMap(map['destination']),
      departureTime: DateTime.parse(map['departureTime']), //'departureTime'],
      maxArrivalTime:
          DateTime.parse(map['maxArrivalTime']), //['maxArrivalTime'],
      distance: map['distance'].toDouble(),
      duration: map['duration'].toDouble(),
      preferences: RidePreferencesModel.fromMap(map['preferences']),
      isRecurring: map['isRecurring'],
      car: CarDetailsModel.fromMap(map['car']),
      recurringRides: List<dynamic>.from(map['recurringRides']),
      paymentMethod: List<String>.from(map['paymentMethod']),
      fare: map['fare'].toDouble(),
      status: map['status'],
      environmentStats: EnvironmentStatsModel.fromMap(map['environmentStats']),
      expectedArrivalTime:
          DateTime.parse(map['expectedArrivalTime']), //['expectedArrivalTime'],
      routeCoords: List<List<double>>.from(
          map['routeCoords'].map((coords) => List<double>.from(coords))),
      passengers: List<InridePassengerModel>.from(map['passengers']
          .map((passenger) => InridePassengerModel.fromMap(passenger))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'driverId': driverId,
      'numOfSeats': numOfSeats,
      'date': date,
      'source': source.toMap(),
      'destination': destination.toMap(),
      'departureTime': departureTime,
      'maxArrivalTime': maxArrivalTime,
      'distance': distance,
      'duration': duration,
      'preferences': preferences.toMap(),
      'isRecurring': isRecurring,
      'car': car.toMap(),
      'recurringRides': recurringRides,
      'paymentMethod': paymentMethod,
      'fare': fare,
      'status': status,
      'environmentStats': environmentStats.toMap(),
      'expectedArrivalTime': expectedArrivalTime,
      'routeCoords': routeCoords
          .map((coords) => coords.map((coord) => coord).toList())
          .toList(),
      'passengers': passengers.map((passenger) => passenger.toMap()).toList(),
    };
  }
}
