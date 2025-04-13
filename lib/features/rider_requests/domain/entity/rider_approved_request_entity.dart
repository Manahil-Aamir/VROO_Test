import '../../../cars/domain/entity/car.dart';
import '../../../driver_requests/domain/entity/location_entity.dart';
import '../../../driver_requests/domain/entity/ratings.dart';

class ApprovedRideEntity {
  final String id;
  final String driverId;
  final LocationEntity source;
  final LocationEntity destination;
  final DateTime date;
  final DateTime departureTime;
  final CarEntity car;
  final List<PassengerInfoEntity> passengerInfo;
  final DriverEntity driver;

  ApprovedRideEntity({
    required this.id,
    required this.driverId,
    required this.source,
    required this.destination,
    required this.date,
    required this.departureTime,
    required this.car,
    required this.passengerInfo,
    required this.driver,
  });
}

class PassengerInfoEntity {
  final String name;
  final Ratings ratings;

  PassengerInfoEntity({
    required this.name,
    required this.ratings,
  });
}

class DriverEntity {
  final String name;
  final Ratings rating;
  final TotalRides totalRides;
  final String phoneNumber;

  DriverEntity({
    required this.name,
    required this.rating,
    required this.totalRides,
    required this.phoneNumber,
  });
}

class TotalRides {
  final int asDriver;
  final int asRider;

  TotalRides({
    required this.asDriver,
    required this.asRider,
  });
}