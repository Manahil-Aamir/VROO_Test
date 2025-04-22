import '../../../cars/domain/entity/car.dart';
import '../../../../shared/domain/entity/location_entity.dart';
import '../../../../shared/domain/entity/ratings.dart';
import 'driver_rider_detail.dart';

class RiderApprovedRequest {
  final String id;
  final String driverId;
  final LocationEntity source;
  final LocationEntity destination;
  final DateTime date;
  final DateTime departureTime;
  final CarEntity car;
  final List<DriverRiderDetail> passengers;  
  final DriverEntity driver;

  RiderApprovedRequest({
    required this.id,
    required this.driverId,
    required this.source,
    required this.destination,
    required this.date,
    required this.departureTime,
    required this.car,
    required this.passengers,
    required this.driver,
  });
}

class DriverEntity {
  final String name;
  final Ratings rating;
  final TotalRides totalRides;
  final String phoneNumber;
  final String fcmToken;

  DriverEntity({
    required this.name,
    required this.rating,
    required this.totalRides,
    required this.phoneNumber,
    required this.fcmToken,
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
