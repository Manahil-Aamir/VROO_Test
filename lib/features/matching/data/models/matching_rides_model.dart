import '../../../../shared/data/models/location_modal.dart';
import '../../../cars/data/model/carr_model.dart';
import '../../../rider_journey/data/model/ride_journey_model.dart';

class RideResponseModel {
  final bool success;
  final String message;
  final RideRequestData data;

  const RideResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RideResponseModel.fromJson(Map<String, dynamic> json) {
    print('In RideResponseModel fromJson');
    return RideResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: RideRequestData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class RideRequestData {
  final List<MatchingRideModel> matchingRides;
  final String message;
  final String rideRequestId;

  const RideRequestData({
    required this.matchingRides,
    required this.message,
    required this.rideRequestId,
  });

  factory RideRequestData.fromJson(Map<String, dynamic> json) {
    print('In RideRequestData fromJson');
    return RideRequestData(
      matchingRides: (json['matchingRides'] as List?)
              ?.map((e) => MatchingRideModel.fromJson(e))
              .toList() ??
          [],
      message: json['message'] ?? '',
      rideRequestId: json['rideRequestId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchingRides': matchingRides.map((e) => e.toJson()).toList(),
      'message': message,
      'rideRequestId': rideRequestId,
    };
  }
}

class MatchingRideModel {
  final String id;
  final Car car;
  final DateTime date;
  final DateTime departureTime;
  final LocationModel destination;
  final double distance;
  final String driverGender;
  final String driverId;
  final double driverRating;
  final String driverName;
  final double duration;
  final EnvironmentStatsModel environmentStats;
  final List<dynamic> existingRequests;
  final DateTime expectedArrivalTime;
  final double fare;
  final bool isRecurring;
  final DateTime maxArrivalTime;
  final List<dynamic> neighbourRouteCells;
  final int numOfSeats;
  final List<PassengerModel> passengers;
  final List<String> paymentMethod;
  final RidePreferencesModel preferences;
  // final List<dynamic> recurringRides;
  // final List<dynamic> recurringRides;
  final List<String> routeCells;
  final List<List<double>> routeCoords;
  final LocationModel source;
  final String status;
  final double totalDetourDistance;
  final double totalDetourDuration;
  final double totalRecommended;

  const MatchingRideModel({
    required this.id,
    required this.car,
    required this.date,
    required this.departureTime,
    required this.destination,
    required this.distance,
    required this.driverGender,
    required this.driverId,
    required this.driverName,
    required this.driverRating,
    required this.duration,
    required this.environmentStats,
    required this.existingRequests,
    required this.expectedArrivalTime,
    required this.fare,
    required this.isRecurring,
    required this.maxArrivalTime,
    required this.neighbourRouteCells,
    required this.numOfSeats,
    required this.passengers,
    required this.paymentMethod,
    required this.preferences,
    //required this.recurringRides,
    required this.routeCells,
    required this.routeCoords,
    required this.source,
    required this.status,
    required this.totalDetourDistance,
    required this.totalDetourDuration,
    required this.totalRecommended
  });

  factory MatchingRideModel.fromJson(Map<String, dynamic> json) {
    print('In MatchingRideModel fromJson');
    return MatchingRideModel(
      id: json['_id'],
      car: Car.fromJson(json['car']),
      date: DateTime.parse(json['date']),
      departureTime: DateTime.parse(json['departureTime']),
      destination: LocationModel.fromJson(json['destination']),
      distance: (json['distance'] as num).toDouble(),
      driverGender: json['driverGender'],
      driverId: json['driverId'],
      driverName: json['driverName'],
      driverRating: json['driverRating'],
      duration: (json['duration'] as num).toDouble(),
      environmentStats:
          EnvironmentStatsModel.fromJson(json['environmentStats']),
      existingRequests: List<dynamic>.from(json['existing_requests']),
      expectedArrivalTime: DateTime.parse(
          json['expectedArrivalTime']), // Parse time string to DateTime
      fare: (json['fare'] as num).toDouble(),
      isRecurring: json['isRecurring'],
      maxArrivalTime: DateTime.parse(
          json['maxArrivalTime']), // Parse time string to DateTime
      neighbourRouteCells: List<dynamic>.from(json['neighbourRouteCells']),
      numOfSeats: (json['numOfSeats'] as num).toInt(),
      passengers: (json['passengers'] as List)
          .map((e) => PassengerModel.fromJson(e))
          .toList(),
      paymentMethod: List<String>.from(json['paymentMethod']),
      preferences: RidePreferencesModel.fromJson(json['preferences']),
      // recurringRides: List<dynamic>.from(json['recurringRides']),
      routeCells: List<String>.from(json['routeCells']),
      routeCoords: (json['routeCoords'] as List)
          .map((e) => List<double>.from(e.map((v) => (v as num).toDouble())))
          .toList(),
      source: LocationModel.fromJson(json['source']),
      status: json['status'],
      totalDetourDistance: (json['totalDetourDistance'] as num).toDouble(),
      totalDetourDuration: (json['totalDetourDuration'] as num).toDouble(),
      totalRecommended: json['totalRecommended']?? 2
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'car': car.toJson(),
      'date': date,
      'departureTime': departureTime.toIso8601String(),
      'destination': destination.toJson(),
      'distance': distance,
      'driverGender': driverGender,
      'driverId': driverId,
      'driverName': driverName,
      'driverRating': driverRating,
      'duration': duration,
      'environmentStats': environmentStats.toJson(),
      'existing_requests': existingRequests,
      'expectedArrivalTime': expectedArrivalTime.toIso8601String(),
      'fare': fare,
      'isRecurring': isRecurring,
      'maxArrivalTime': maxArrivalTime.toIso8601String(),
      'neighbourRouteCells': neighbourRouteCells,
      'numOfSeats': numOfSeats,
      'passengers': passengers.map((e) => e.toJson()).toList(),
      'paymentMethod': paymentMethod,
      'preferences': preferences.toJson(),
      // 'recurringRides': recurringRides,
      'routeCells': routeCells,
      'routeCoords': routeCoords,
      'source': source.toJson(),
      'status': status,
      'totalDetourDistance': totalDetourDistance,
      'totalDetourDuration': totalDetourDuration,
      'totalRecommended': totalRecommended,
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
      co2Saved: (json['CO2Saved'] as num?)?.toDouble() ?? 0.0,
      fuelSaved: (json['fuelSaved'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CO2Saved': co2Saved,
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
      eta: json['eta'] ?? '',
      fare: (json['fare'] as num?)?.toDouble() ?? 0.0,
      rideRequestId: json['rideRequestId'] ?? '',
      riderId: json['riderId'] ?? '',
      status: json['status'] ?? '',
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
