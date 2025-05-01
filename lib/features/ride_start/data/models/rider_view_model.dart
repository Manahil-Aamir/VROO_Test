import 'package:vroo_test/features/ride_start/data/models/address_model.dart';
import 'package:vroo_test/features/ride_start/data/models/gender_preference_model.dart';
import 'package:vroo_test/features/ride_start/data/models/others_model.dart';
import 'package:vroo_test/features/ride_start/data/models/riding_passenger_model.dart';
import 'package:vroo_test/features/ride_start/domain/entities/rider_view_entity.dart';

import '../../../cars/data/model/carr_model.dart';

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
    required super.carDetails,
  });

  factory RideViewModel.fromMap(Map<String, dynamic> json) {
    // Print the runtime type of each field in the JSON map
    print('_id type: ${json['_id'].runtimeType}, value: ${json['_id']}');
    print(
        'DriverId type: ${json['driverId'].runtimeType}, value: ${json['driverId']}');
    print(
        'DriverName type: ${json['driverName'].runtimeType}, value: ${json['driverName']}');
    print(
        'DriverGender type: ${json['driverGender'].runtimeType}, value: ${json['driverGender']}');
    print(
        'NumOfSeats type: ${json['numOfSeats'].runtimeType}, value: ${json['numOfSeats']}');
    print('Date type: ${json['date'].runtimeType}, value: ${json['date']}');
    print(
        'Source type: ${json['source'].runtimeType}, value: ${json['source']}');
    print(
        'Destination type: ${json['destination'].runtimeType}, value: ${json['destination']}');
    print(
        'DepartureTime type: ${json['departureTime'].runtimeType}, value: ${json['departureTime']}');
    print(
        'MaxArrivalTime type: ${json['maxArrivalTime'].runtimeType}, value: ${json['maxArrivalTime']}');
    print(
        'Distance type: ${json['distance'].runtimeType}, value: ${json['distance']}');
    print(
        'Duration type: ${json['duration'].runtimeType}, value: ${json['duration']}');
    print(
        'TotalDetourDistance type: ${json['totalDetourDistance'].runtimeType}, value: ${json['totalDetourDistance']}');
    print(
        'TotalDetourDuration type: ${json['totalDetourDuration'].runtimeType}, value: ${json['totalDetourDuration']}');
    print('RouteCells type: ${json['routeCells'].runtimeType}');
    print(
        'NeighbourRouteCells type: ${json['neighbourRouteCells'].runtimeType}');
    print('Preferences type: ${json['preferences'].runtimeType}');
    print('IsRecurring type: ${json['isRecurring'].runtimeType}');
    print('RecurringRides type: ${json['recurringRides'].runtimeType}');
    print('PaymentMethod type: ${json['paymentMethod'].runtimeType}');
    print('Fare type: ${json['fare'].runtimeType}');
    print('Status type: ${json['status'].runtimeType}');
    print(
        'ExpectedArrivalTime type: ${json['expectedArrivalTime'].runtimeType}');
    print('RouteCoords type: ${json['routeCoords'].runtimeType}');
    print('PassengerData type: ${json['passengerData'].runtimeType}');
    print('OtherPassengers type: ${json['otherPassengers'].runtimeType}');
    print('Car type: ${json['car'].runtimeType}');
    void logWarning(String key, dynamic value) {
      if (value == null) {
        // Replace this with your preferred logging framework
        print('Warning: $key is null');
      } else {
        // Replace this with your preferred logging framework
        print('Info: $key is not null, value: $value');
      }
    }

    // Validate and log warnings for null values before mapping
    logWarning('_id', json['_id']);
    logWarning('driverId', json['driverId']);
    logWarning('driverName', json['driverName']);
    logWarning('driverGender', json['driverGender']);
    logWarning('numOfSeats', json['numOfSeats']);
    logWarning('date', json['date']);
    logWarning('source', json['source']);
    logWarning('destination', json['destination']);
    logWarning('departureTime', json['departureTime']);
    logWarning('maxArrivalTime', json['maxArrivalTime']);
    logWarning('distance', json['distance']);
    logWarning('duration', json['duration']);
    logWarning('totalDetourDistance', json['totalDetourDistance']);
    logWarning('totalDetourDuration', json['totalDetourDuration']);
    logWarning('routeCells', json['routeCells']);
    logWarning('neighbourRouteCells', json['neighbourRouteCells']);
    logWarning('preferences', json['preferences']);
    logWarning('isRecurring', json['isRecurring']);
    logWarning('recurringRides', json['recurringRides']);
    logWarning('paymentMethod', json['paymentMethod']);
    logWarning('fare', json['fare']);
    logWarning('status', json['status']);
    logWarning('expectedArrivalTime', json['expectedArrivalTime']);
    logWarning('routeCoords', json['routeCoords']);
    logWarning('passengerData', json['passengerData']);
    logWarning('otherPassengers', json['otherPassengers']);
    logWarning('car', json['car']);

    return RideViewModel(
      id: json['_id'] ?? '',
      driverId: json['driverId'] ?? '',
      driverName: json['driverName'] ?? '',
      driverGender: json['driverGender'] ?? '',
      numOfSeats: json['numOfSeats'] ?? 0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      source: AddressModel.fromMap(json['source'] ?? {}),
      destination: AddressModel.fromMap(json['destination'] ?? {}),
      departureTime:
          DateTime.tryParse(json['departureTime'] ?? '') ?? DateTime.now(),
      maxArrivalTime:
          DateTime.tryParse(json['maxArrivalTime'] ?? '') ?? DateTime.now(),
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
      expectedArrivalTime:
          DateTime.tryParse(json['expectedArrivalTime'] ?? '') ??
              DateTime.now(),
      routeCoords: List<List<double>>.from(
          json['routeCoords']?.map((x) => List<double>.from(x)) ?? []),
      passengerData: RidingPassengerModel.fromMap(json['passengerData'] ?? {}),
      otherPassengers: List<OthersModel>.from(
          json['otherPassengers']?.map((x) => OthersModel.fromMap(x)) ?? []),
      carDetails: Car.fromJson(json['car'] ?? {}),
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
      'carDetails': (carDetails).toJson(),
    };
  }
}
