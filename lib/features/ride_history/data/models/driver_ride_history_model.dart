// data/model/passenger_model.dart
import '../../../../shared/data/models/location_modal.dart';
import '../../../cars/data/model/carr_model.dart';
import '../../domain/entity/driver_history_entity.dart';

class PassengerModel {
  final String riderId;
  final String status;
  final double fare;
  final String rideRequestId;
  final String? review;
  final String eta;
  final int detourDistance;
  final int detourDuration;
  final String gender;
  final bool sameDestination;
  final bool sameSource;

  PassengerModel({
    required this.riderId,
    required this.status,
    required this.fare,
    required this.rideRequestId,
    this.review,
    required this.eta,
    required this.detourDistance,
    required this.detourDuration,
    required this.gender,
    required this.sameDestination,
    required this.sameSource,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      riderId: json['riderId'] ?? '',
      status: json['status'] ?? '',
      fare: json['fare']?.toDouble() ?? 0.0,
      rideRequestId: json['rideRequestId'] ?? '',
      review: json['review'],
      eta: json['eta'] ?? '',
      detourDistance: json['detourDistance'] ?? 0,
      detourDuration: json['detourDuration'] ?? 0,
      gender: json['gender'] ?? '',
      sameDestination: json['sameDestination'] ?? false,
      sameSource: json['sameSource'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'riderId': riderId,
      'status': status,
      'fare': fare,
      'rideRequestId': rideRequestId,
      'review': review,
      'eta': eta,
      'detourDistance': detourDistance,
      'detourDuration': detourDuration,
      'gender': gender,
      'sameDestination': sameDestination,
      'sameSource': sameSource,
    };
  }

  PassengerEntity toEntity() => PassengerEntity(
        riderId: riderId,
        status: status,
        fare: fare,
        rideRequestId: rideRequestId,
        review: review,
        eta: eta,
        detourDistance: detourDistance,
        detourDuration: detourDuration,
        gender: gender,
        sameDestination: sameDestination,
        sameSource: sameSource,
      );
}

// data/model/ride_model.dart
class RideModel {
  final String id;
  final String driverId;
  final String driverName;
  final String date;
  final LocationModel source;
  final LocationModel destination;
  final String departureTime;
  final Car car;
  final List<String> paymentMethod;
  final double fare;
  final List<PassengerModel> passengers;
  final String expectedArrivalTime;

  RideModel({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.date,
    required this.source,
    required this.destination,
    required this.departureTime,
    required this.car,
    required this.paymentMethod,
    required this.fare,
    required this.passengers,
    required this.expectedArrivalTime,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['_id'] ?? '',
      driverId: json['driverId'] ?? '',
      driverName: json['driverName'] ?? '',
      date: json['date'] ?? '',
      source: LocationModel.fromJson(json['source'] ?? {}),
      destination: LocationModel.fromJson(json['destination'] ?? {}),
      departureTime: json['departureTime'] ?? '',
      car: Car.fromJson(json['car'] ?? {}),
      paymentMethod: List<String>.from(json['paymentMethod'] ?? []),
      fare: json['fare']?.toDouble() ?? 0.0,
      passengers: (json['passengers'] as List<dynamic>?)
              ?.map((e) => PassengerModel.fromJson(e))
              .toList() ??
          [],
      expectedArrivalTime: json['expectedArrivalTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'driverId': driverId,
      'driverName': driverName,
      'date': date,
      'source': source.toJson(),
      'destination': destination.toJson(),
      'departureTime': departureTime,
      'car': car.toJson(),
      'paymentMethod': paymentMethod,
      'fare': fare,
      'passengers': passengers.map((e) => e.toJson()).toList(),
      'expectedArrivalTime': expectedArrivalTime,
    };
  }

  RideEntity toEntity() => RideEntity(
        id: id,
        driverId: driverId,
        driverName: driverName,
        date: date,
        source: source.toEntity(),
        destination: destination.toEntity(),
        departureTime: departureTime,
        car: car.toEntity(),
        paymentMethod: paymentMethod,
        fare: fare,
        passengers: passengers.map((e) => e.toEntity()).toList(),
        expectedArrivalTime: expectedArrivalTime,
      );
}

// data/model/ride_history_model.dart
class RideHistoryModel {
  final List<RideModel> completedRides;
  final List<RideModel> cancelledRides;

  RideHistoryModel({
    required this.completedRides,
    required this.cancelledRides,
  });

  factory RideHistoryModel.fromJson(Map<String, dynamic> json) {
    return RideHistoryModel(
      completedRides: (json['completedRides'] as List<dynamic>?)
              ?.map((e) => RideModel.fromJson(e))
              .toList() ??
          [],
      cancelledRides: (json['cancelledRides'] as List<dynamic>?)
              ?.map((e) => RideModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completedRides': completedRides.map((e) => e.toJson()).toList(),
      'cancelledRides': cancelledRides.map((e) => e.toJson()).toList(),
    };
  }

  DriverHistoryEntity toEntity() => DriverHistoryEntity(
        completedRides: completedRides.map((e) => e.toEntity()).toList(),
        cancelledRides: cancelledRides.map((e) => e.toEntity()).toList(),
      );
}
