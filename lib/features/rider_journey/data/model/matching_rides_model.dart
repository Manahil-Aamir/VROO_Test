import 'package:vroo_test/features/rider_journey/data/model/ride_journey_model.dart';
import '../../domain/entity/matching_rides_entity.dart';

// Models
class MatchingRideModel extends MatchingRide {
  const MatchingRideModel({
    required super.id,
    required super.car,
    required super.date,
    required super.departureTime,
    required super.source,
    required super.destination,
    required super.distance,
    required super.driverId,
    required super.duration,
    required super.environmentStats,
    required super.expectedArrivalTime,
    required super.fare,
    required super.isRecurring,
    required super.maxArrivalTime,
    required super.neighbourRouteCells,
    required super.numOfSeats,
    required super.passengers,
    required super.paymentMethod,
    required super.preferences,
    required super.recurringRides,
    required super.routeCells,
    required super.routeCoords,
    required super.status,
    required super.totalDetourDistance,
    required super.totalDetourDuration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'car': car.toMap(),
      'date': date,
      'departureTime': departureTime,
      'source': source.toMap(),
      'destination': destination.toMap(),
      'distance': distance,
      'driverId': driverId,
      'duration': duration,
      'environmentStats': environmentStats.toMap(),
      'expectedArrivalTime': expectedArrivalTime,
      'fare': fare,
      'isRecurring': isRecurring,
      'maxArrivalTime': maxArrivalTime,
      'neighbourRouteCells': neighbourRouteCells,
      'numOfSeats': numOfSeats,
      'passengers': passengers.map((p) => p.toMap()).toList(),
      'paymentMethod': paymentMethod,
      'preferences': preferences.toMap(),
      'recurringRides': recurringRides,
      'routeCells': routeCells,
      'routeCoords': routeCoords.map((x) => x.toList()).toList(),
      'status': status,
      'totalDetourDistance': totalDetourDistance,
      'totalDetourDuration': totalDetourDuration,
    };
  }

  factory MatchingRideModel.fromMap(Map<String, dynamic> map) {
    // print("DEBUG: Type of id -> ${map['id']?.runtimeType}");
    // print("DEBUG: Type of car -> ${map['car']?.runtimeType}");
    // print("DEBUG: Type of date -> ${map['date']?.runtimeType}");
    // print(
    //     "DEBUG: Type of departureTime -> ${map['departureTime']?.runtimeType}");
    // print("DEBUG: Type of source -> ${map['source']?.runtimeType}");
    // print("DEBUG: Type of destination -> ${map['destination']?.runtimeType}");
    // print("DEBUG: Type of distance -> ${map['distance']?.runtimeType}");
    // print("DEBUG: Type of driverId -> ${map['driverId']?.runtimeType}");
    // print("DEBUG: Type of duration -> ${map['duration']?.runtimeType}");
    // print(
    //     "DEBUG: Type of environmentStats -> ${map['environmentStats']?.runtimeType}");
    // print(
    //     "DEBUG: Type of expectedArrivalTime -> ${map['expectedArrivalTime']?.runtimeType}");
    // print("DEBUG: Type of fare -> ${map['fare']?.runtimeType}");
    // print("DEBUG: Type of isRecurring -> ${map['isRecurring']?.runtimeType}");
    // print(
    //     "DEBUG: Type of maxArrivalTime -> ${map['maxArrivalTime']?.runtimeType}");
    // print(
    //     "DEBUG: Type of neighbourRouteCells -> ${map['neighbourRouteCells']?.runtimeType}");
    // print("DEBUG: Type of numOfSeats -> ${map['numOfSeats']?.runtimeType}");
    // print("DEBUG: Type of passengers -> ${map['passengers']?.runtimeType}");
    // print(
    //     "DEBUG: Type of paymentMethod -> ${map['paymentMethod']?.runtimeType}");
    // print("DEBUG: Type of preferences -> ${map['preferences']?.runtimeType}");
    // print(
    //     "DEBUG: Type of recurringRides -> ${map['recurringRides']?.runtimeType}");
    // print("DEBUG: Type of routeCells -> ${map['routeCells']?.runtimeType}");
    // print("DEBUG: Type of routeCoords -> ${map['routeCoords']?.runtimeType}");
    // print("DEBUG: Type of status -> ${map['status']?.runtimeType}");
    // print(
    //     "DEBUG: Type of totalDetourDistance -> ${map['totalDetourDistance']?.runtimeType}");
    // print(
    //     "DEBUG: Type of totalDetourDuration -> ${map['totalDetourDuration']?.runtimeType}");
    return MatchingRideModel(
      id: map['_id'] ?? '',
      car: CarDetailsModel.fromMap(map['car'] ?? {}),
      date: map['date'] ?? '',
      departureTime: map['departureTime'] ?? '',
      source: RideLocationModel.fromMap(map['source'] ?? {}),
      destination: RideLocationModel.fromMap(map['destination'] ?? {}),
      distance: map['distance'] ?? 0.0,
      driverId: map['driverId'] ?? '',
      duration: map['duration'] ?? 0.0,
      environmentStats:
          EnvironmentStatsModel.fromMap(map['environmentStats'] ?? {}),
      expectedArrivalTime: map['expectedArrivalTime'] ?? '',
      fare: map['fare'] ?? 0.0,
      isRecurring: map['isRecurring'] ?? false,
      maxArrivalTime: map['maxArrivalTime'] ?? '',
      neighbourRouteCells: List<String>.from(map['neighbourRouteCells'] ?? []),
      numOfSeats: map['numOfSeats'] ?? 0,
      passengers: List<PassengerModel>.from(
          (map['passengers'] ?? []).map((x) => PassengerModel.fromMap(x))),
      paymentMethod: List<String>.from(map['paymentMethod'] ?? []),
      preferences: RidePreferencesModel.fromMap(map['preferences'] ?? {}),
      recurringRides: List<String>.from(map['recurringRides'] ?? []),
      routeCells: List<String>.from(map['routeCells'] ?? []),
      routeCoords: (map['routeCoords'] ?? [])
          .map<List<double>>((x) => List<double>.from(x))
          .toList(),
      status: map['status'] ?? '',
      totalDetourDistance: map['totalDetourDistance'] ?? 0.0,
      totalDetourDuration: map['totalDetourDuration'] ?? 0.0,
    );
  }
}

class CarDetailsModel extends CarDetails {
  const CarDetailsModel({
    required super.color,
    required super.company,
    required super.isVerified,
    required super.mileage,
    required super.model,
    required super.numberPlate,
  });

  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'company': company,
      'isVerified': isVerified,
      'mileage': mileage,
      'model': model,
      'numberPlate': numberPlate,
    };
  }

  factory CarDetailsModel.fromMap(Map<String, dynamic> map) {
    return CarDetailsModel(
      color: map['color'] ?? '',
      company: map['company'] ?? '',
      isVerified: map['isVerified'] ?? false,
      mileage: map['mileage'] ?? 0.0,
      model: map['model'] ?? '',
      numberPlate: map['numberPlate'] ?? '',
    );
  }
}

class PassengerModel extends Passenger {
  const PassengerModel({
    required super.eta,
    required super.fare,
    required super.rideRequestId,
    required super.riderId,
    required super.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'eta': eta,
      'fare': fare,
      'rideRequestId': rideRequestId,
      'riderId': riderId,
      'status': status,
    };
  }

  factory PassengerModel.fromMap(Map<String, dynamic> map) {
    return PassengerModel(
      eta: map['eta'] ?? '',
      fare: map['fare'] ?? 0.0,
      rideRequestId: map['rideRequestId'] ?? '',
      riderId: map['riderId'] ?? '',
      status: map['status'] ?? '',
    );
  }
}

class RideResponseModel extends RideResponse {
  const RideResponseModel({
    required super.message,
    required super.rideRequestId,
    required super.matchingRides,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'rideRequestId': rideRequestId,
      'matchingRides': matchingRides.map((r) => r.toMap()).toList(),
    };
  }

  factory RideResponseModel.fromMap(Map<String, dynamic> map) {
    return RideResponseModel(
      message: map['message'] ?? '',
      rideRequestId: map['rideRequestId'] ?? '',
      matchingRides: List<MatchingRideModel>.from((map['matchingRides'] ?? [])
          .map((x) => MatchingRideModel.fromMap(x))),
    );
  }
}

class EnvironmentStatsModel extends EnvironmentStats {
  const EnvironmentStatsModel({
    required super.co2Saved,
    required super.fuelSaved,
  });

  Map<String, dynamic> toMap() {
    return {
      'co2Saved': co2Saved,
      'fuelSaved': fuelSaved,
    };
  }

  factory EnvironmentStatsModel.fromMap(Map<String, dynamic> map) {
    return EnvironmentStatsModel(
      co2Saved: map['co2Saved'] ?? 0.0,
      fuelSaved: map['fuelSaved'] ?? 0.0,
    );
  }
}
