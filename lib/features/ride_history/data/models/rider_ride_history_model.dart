// data/model/rider_history/rider_model.dart
import '../../../../shared/data/models/location_modal.dart';
import '../../../cars/data/model/carr_model.dart';
import '../../domain/entity/rider_history_entity.dart';

class RiderModel {
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
  final String riderName;
  final LocationModel source;
  final LocationModel destination;
  final PickupTimeRangeModel pickupTimeRange; // Updated from Map to structured class

  RiderModel({
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
    required this.riderName,
    required this.source,
    required this.destination,
    required this.pickupTimeRange,
  });

  factory RiderModel.fromJson(Map<String, dynamic> json) {
    return RiderModel(
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
      riderName: json['riderName'] ?? '',
      source: LocationModel.fromJson(json['source'] ?? {}),
      destination: LocationModel.fromJson(json['destination'] ?? {}),
      pickupTimeRange: PickupTimeRangeModel.fromJson(json['pickupTimeRange'] ?? {}),
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
      'riderName': riderName,
      'source': source.toJson(),
      'destination': destination.toJson(),
      'pickupTimeRange': pickupTimeRange,
    };
  }

  RiderEntity toEntity() => RiderEntity(
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
        riderName: riderName,
        source: source.toEntity(),
        destination: destination.toEntity(),
        pickupTimeRange: pickupTimeRange.toEntity(),
      );
}

// data/model/rider_history/rider_ride_model.dart
class RiderRideModel {
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
  final String expectedArrivalTime;
  final List<String> passengersName;
  final RiderModel rider;

  RiderRideModel({
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
    required this.expectedArrivalTime,
    required this.passengersName,
    required this.rider,
  });

  factory RiderRideModel.fromJson(Map<String, dynamic> json) {
    return RiderRideModel(
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
      expectedArrivalTime: json['expectedArrivalTime'] ?? '',
      passengersName: List<String>.from(json['passengersName'] ?? []),
      rider: RiderModel.fromJson(json['rider'] ?? {}),
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
      'expectedArrivalTime': expectedArrivalTime,
      'passengersName': passengersName,
      'rider': rider.toJson(),
    };
  }

  RiderRideEntity toEntity() => RiderRideEntity(
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
        expectedArrivalTime: expectedArrivalTime,
        passengersName: passengersName,
        rider: rider.toEntity(),
      );
}

// data/model/rider_history/rider_history_model.dart
class RiderHistoryModel {
  final List<RiderRideModel> completedRides;
  final List<RiderRideModel> cancelledRides;

  RiderHistoryModel({
    required this.completedRides,
    required this.cancelledRides,
  });

  factory RiderHistoryModel.fromJson(Map<String, dynamic> json) {
    return RiderHistoryModel(
      completedRides: (json['completedRides'] as List<dynamic>?)
              ?.map((e) => RiderRideModel.fromJson(e))
              .toList() ??
          [],
      cancelledRides: (json['cancelledRides'] as List<dynamic>?)
              ?.map((e) => RiderRideModel.fromJson(e))
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

  RiderHistoryEntity toEntity() => RiderHistoryEntity(
        completedRides: completedRides.map((e) => e.toEntity()).toList(),
        cancelledRides: cancelledRides.map((e) => e.toEntity()).toList(),
      );
}

class PickupTimeRangeModel {
  final DateTime min; // Earliest pickup time
  final DateTime max; // Latest pickup time

  PickupTimeRangeModel({
    required this.min,
    required this.max,
  });

  factory PickupTimeRangeModel.fromJson(Map<String, dynamic> json) {
    return PickupTimeRangeModel(
      min: DateTime.parse(json['min'] ?? ''), // Parse ISO string to DateTime
      max: DateTime.parse(json['max'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min.toIso8601String(), // Convert DateTime back to ISO string
      'max': max.toIso8601String(),
    };
  }

  PickupTimeRangeEntity toEntity() => PickupTimeRangeEntity(
        min: min,
        max: max,
      );
}
