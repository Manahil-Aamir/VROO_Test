import 'package:vroo_test/features/ride_start/data/models/inride_passenger_model.dart';
import 'package:vroo_test/features/ride_start/domain/entities/ridestart_data_entity.dart';

import '../../../cars/data/model/carr_model.dart';
import '../../../driver_requests/data/model/active_ride_model.dart';
import '../../../matching/data/models/matching_rides_model.dart';
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
    print('id: ${map['_id']}');
    print('driverId: ${map['driverId']}');
    print('numOfSeats: ${map['numOfSeats']}');
    print('date: ${map['date']}');
    print('source: ${map['source']}');
    print('destination: ${map['destination']}');
    print('departureTime: ${map['departureTime']}');
    print('maxArrivalTime: ${map['maxArrivalTime']}');
    print('distance: ${map['distance']}');
    print('duration: ${map['duration']}');
    print('preferences: ${map['preferences']}');
    print('isRecurring: ${map['isRecurring']}');
    print('car: ${map['car']}');
    print('recurringRides: ${map['recurringRides']}');
    print('paymentMethod: ${map['paymentMethod']}');
    print('fare: ${map['fare']}');
    print('status: ${map['status']}');
    print('environmentStats: ${map['environmentStats']}');
    print('expectedArrivalTime: ${map['expectedArrivalTime']}');
    print('routeCoords: ${map['routeCoords']}');
    print('passengers: ${map['passengers']}');

    return RidestartDataModel(
      id: map['_id'] ?? '',
      driverId: map['driverId'] ?? '',
      numOfSeats: (map['numOfSeats'] ?? 0).toDouble(),
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      source: AddressModel.fromMap(map['source']),
      destination: AddressModel.fromMap(map['destination']),
      departureTime: map['departureTime'] != null
          ? DateTime.parse(map['departureTime'])
          : DateTime.now(),
      maxArrivalTime: map['maxArrivalTime'] != null
          ? DateTime.parse(map['maxArrivalTime'])
          : DateTime.now(),
      distance:
          map['distance'] != null ? (map['distance'] as num).toDouble() : 0.0,
      duration:
          map['duration'] != null ? (map['duration'] as num).toDouble() : 0.0,
      preferences: RidePreferencesModel.fromJson(map['preferences']),
      isRecurring: map['isRecurring'] ?? false,
      car: Car.fromJson(map['car']),
      recurringRides: map['recurringRides'] != null
          ? List<dynamic>.from(map['recurringRides'])
          : [],
      paymentMethod: map['paymentMethod'] != null
          ? List<String>.from(map['paymentMethod'])
          : [],
      fare: map['fare'] != null ? (map['fare'] as num).toDouble() : 0.0,
      status: map['status'] ?? '',
      environmentStats: EnvironmentStatsModel.fromJson(map['environmentStats']),
      expectedArrivalTime: map['expectedArrivalTime'] != null
          ? DateTime.parse(map['expectedArrivalTime'])
          : DateTime.now(),
      routeCoords: map['routeCoords'] != null
          ? List<List<double>>.from(
              map['routeCoords'].map((coords) => List<double>.from(coords)))
          : [],
      passengers: (map['passengers'] != null &&
              map['passengers'] is List &&
              map['passengers'].any((p) => p != null && p.isNotEmpty))
          ? List<InridePassengerModel>.from(
              map['passengers']
                  .where((p) => p != null && p.isNotEmpty)
                  .map((passenger) => InridePassengerModel.fromMap(passenger)),
            )
          : [],
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
      'preferences': preferences.toJson(),
      'isRecurring': isRecurring,
      'car': car.toJson(),
      'recurringRides': recurringRides,
      'paymentMethod': paymentMethod,
      'fare': fare,
      'status': status,
      'environmentStats': environmentStats.toJson(),
      'expectedArrivalTime': expectedArrivalTime,
      'routeCoords': routeCoords
          .map((coords) => coords.map((coord) => coord).toList())
          .toList(),
      'passengers': passengers.map((passenger) => passenger.toMap()).toList(),
    };
  }
}
