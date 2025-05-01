import 'package:vroo_test/features/ride_start/data/models/address_model.dart';
import 'package:vroo_test/features/ride_start/data/models/gender_preference_model.dart';
import 'package:vroo_test/features/ride_start/data/models/others_model.dart';
import 'package:vroo_test/features/ride_start/data/models/riding_passenger_model.dart';
import 'package:vroo_test/features/ride_start/domain/entities/rider_view_entity.dart';

class RideViewModel extends RideViewEntity {
  const RideViewModel({
    required super.id,
    required super.driverId,
    required super.driverName,
    required super.driverGender,
    required super.numOfSeats,
    required super.date,
    required super.source,
    required super.destination,
    required super.departureTime,
    required super.maxArrivalTime,
    required super.distance,
    required super.duration,
    required super.totalDetourDistance,
    required super.totalDetourDuration,
    required super.routeCells,
    required super.neighbourRouteCells,
    required super.preferences,
    required super.isRecurring,
    required super.recurringRides,
    required super.paymentMethod,
    required super.fare,
    required super.status,
    required super.expectedArrivalTime,
    required super.routeCoords,
    required super.passengerData,
    required super.otherPassengers,
  });

  factory RideViewModel.fromMap(Map<String, dynamic> json) {
    return RideViewModel(
      id: json['_id'] ?? '',
      driverId: json['driverId'] ?? '',
      driverName: json['driverName'] ?? '',
      driverGender: json['driverGender'] ?? '',
      numOfSeats: json['numOfSeats'] ?? 0,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      source: AddressModel.fromMap(json['source'] ?? {}),
      destination: AddressModel.fromMap(json['destination'] ?? {}),
      departureTime: DateTime.parse(
          json['departureTime'] ?? DateTime.now().toIso8601String()),
      maxArrivalTime: DateTime.parse(
          json['maxArrivalTime'] ?? DateTime.now().toIso8601String()),
      distance: json['distance'] ?? 0,
      duration: json['duration'] ?? 0,
      totalDetourDistance: json['totalDetourDistance'] ?? 0,
      totalDetourDuration: json['totalDetourDuration'] ?? 0,
      routeCells: List<String>.from(json['routeCells'] ?? []),
      neighbourRouteCells: List<String>.from(json['neighbourRouteCells'] ?? []),
      preferences: GenderPreferencesModel.fromMap(json['preferences'] ?? {}),
      isRecurring: json['isRecurring'] ?? false,
      recurringRides: List<dynamic>.from(json['recurringRides'] ?? []),
      paymentMethod: List<String>.from(json['paymentMethod'] ?? []),
      fare: (json['fare'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      expectedArrivalTime: DateTime.parse(
          json['expectedArrivalTime'] ?? DateTime.now().toIso8601String()),
      routeCoords: List<List<double>>.from(
          json['routeCoords']?.map((x) => List<double>.from(x)) ?? []),
      passengerData: json['passengerData'] != null
          ? RidingPassengerModel.fromMap(json['passengerData'])
          : null,
      otherPassengers: List<OthersModel>.from(
          json['otherPassengers']?.map((x) => x as Map<String, dynamic>) ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'driverId': driverId,
      'driverName': driverName,
      'driverGender': driverGender,
      'numOfSeats': numOfSeats,
      'date': date.toIso8601String(),
      'source': (source as AddressModel).toMap(),
      'destination': (destination as AddressModel).toMap(),
      'departureTime': departureTime.toIso8601String(),
      'maxArrivalTime': maxArrivalTime.toIso8601String(),
      'distance': distance,
      'duration': duration,
      'totalDetourDistance': totalDetourDistance,
      'totalDetourDuration': totalDetourDuration,
      'routeCells': routeCells,
      'neighbourRouteCells': neighbourRouteCells,
      'preferences': (preferences as GenderPreferencesModel).toMap(),
      'isRecurring': isRecurring,
      'recurringRides': recurringRides,
      'paymentMethod': paymentMethod,
      'fare': fare,
      'status': status,
      'expectedArrivalTime': expectedArrivalTime.toIso8601String(),
      'routeCoords': routeCoords,
      'passengerData': (passengerData as RidingPassengerModel).toMap(),
      'otherPassengers':
          otherPassengers?.map((x) => (x as OthersModel).toMap()).toList() ??
              [],
    };
  }
}
