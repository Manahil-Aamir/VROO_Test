import '../../../cars/data/model/carr_model.dart';
import 'ride_journey_model.dart';

class MatchingRideModel {
  final String id;
  final Car car;
  final String date;
  final String departureTime;
  final RideLocationModel source;
  final RideLocationModel destination;
  final double distance;
  final String driverId;
  final String driverName;
  final String driverGender;
  final double duration;
  final EnvironmentStatsModel environmentStats;
  final String expectedArrivalTime;
  final double fare;
  final bool isRecurring;
  final String maxArrivalTime;
  final List<String> neighbourRouteCells;
  final double numOfSeats;
  final List<PassengerModel> passengers;
  final List<dynamic> paymentMethod;
  final RidePreferencesModel preferences;
  final List<dynamic> recurringRides;
  final List<dynamic> routeCells;
  final List<dynamic> routeCoords;
  final String status;
  final double totalDetourDistance;
  final double totalDetourDuration;

  const MatchingRideModel({
    required this.id,
    required this.car,
    required this.date,
    required this.departureTime,
    required this.source,
    required this.destination,
    required this.distance,
    required this.driverId,
    required this.driverName,
    required this.driverGender,
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

  factory MatchingRideModel.fromJson(Map<String, dynamic> json) {
    return MatchingRideModel(
      id: json['id'],
      car: Car.fromJson(json['car']),
      date: json['date'],
      departureTime: json['departureTime'],
      source: RideLocationModel.fromJson(json['source']),
      destination: RideLocationModel.fromJson(json['destination']),
      distance: json['distance'].toDouble(),
      driverId: json['driverId'],
      driverName: json['driverName'],
      driverGender: json['driverGender'],
      duration: json['duration'].toDouble(),
      environmentStats: EnvironmentStatsModel.fromJson(json['environmentStats']),
      expectedArrivalTime: json['expectedArrivalTime'],
      fare: json['fare'].toDouble(),
      isRecurring: json['isRecurring'],
      maxArrivalTime: json['maxArrivalTime'],
      neighbourRouteCells: List<String>.from(json['neighbourRouteCells']),
      numOfSeats: json['numOfSeats'].toDouble(),
      passengers: (json['passengers'] as List)
          .map((e) => PassengerModel.fromJson(e))
          .toList(),
      paymentMethod: json['paymentMethod'],
      preferences: RidePreferencesModel.fromJson(json['preferences']),
      recurringRides: json['recurringRides'],
      routeCells: json['routeCells'],
      routeCoords: json['routeCoords'],
      status: json['status'],
      totalDetourDistance: json['totalDetourDistance'].toDouble(),
      totalDetourDuration: json['totalDetourDuration'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'car': Car(
        carId: car.carId,
        company: car.company,
        model: car.model,
        color: car.color,
        numberPlate: car.numberPlate,
        mileage: car.mileage,
        isVerified: car.isVerified,
      ).toJson(),
      'date': date,
      'departureTime': departureTime,
      'source': source.toJson(),
      'destination': destination.toJson(),
      'distance': distance,
      'driverId': driverId,
      'driverName': driverName,
      'driverGender': driverGender,
      'duration': duration,
      'environmentStats': environmentStats.toJson(),
      'expectedArrivalTime': expectedArrivalTime,
      'fare': fare,
      'isRecurring': isRecurring,
      'maxArrivalTime': maxArrivalTime,
      'neighbourRouteCells': neighbourRouteCells,
      'numOfSeats': numOfSeats,
      'passengers': passengers.map((e) => e.toJson()).toList(),
      'paymentMethod': paymentMethod,
      'preferences': preferences.toJson(),
      'recurringRides': recurringRides,
      'routeCells': routeCells,
      'routeCoords': routeCoords,
      'status': status,
      'totalDetourDistance': totalDetourDistance,
      'totalDetourDuration': totalDetourDuration,
    };
  }
}

class EnvironmentStatsModel {
  final double co2Saved;
  final double fuelSaved;

  const EnvironmentStatsModel({
    required this.co2Saved,
    required this.fuelSaved,
  });

  factory EnvironmentStatsModel.fromJson(Map<String, dynamic> json) {
    return EnvironmentStatsModel(
      co2Saved: json['co2Saved'].toDouble(),
      fuelSaved: json['fuelSaved'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'co2Saved': co2Saved,
      'fuelSaved': fuelSaved,
    };
  }
}

class PassengerModel {
  final String eta;
  final double fare;
  final String rideRequestId;
  final String riderId;
  final String status;

  const PassengerModel({
    required this.eta,
    required this.fare,
    required this.rideRequestId,
    required this.riderId,
    required this.status,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      eta: json['eta'],
      fare: json['fare'].toDouble(),
      rideRequestId: json['rideRequestId'],
      riderId: json['riderId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eta': eta,
      'fare': fare,
      'rideRequestId': rideRequestId,
      'riderId': riderId,
      'status': status,
    };
  }
}

class RideResponseModel {
  final String message;
  final String rideRequestId;
  final List<MatchingRideModel> matchingRides;

  const RideResponseModel({
    required this.message,
    required this.rideRequestId,
    required this.matchingRides,
  });

  factory RideResponseModel.fromJson(Map<String, dynamic> json) {
    return RideResponseModel(
      message: json['message'],
      rideRequestId: json['rideRequestId'],
      matchingRides: (json['matchingRides'] as List)
          .map((e) => MatchingRideModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'rideRequestId': rideRequestId,
      'matchingRides': matchingRides.map((e) => e.toJson()).toList(),
    };
  }
}
