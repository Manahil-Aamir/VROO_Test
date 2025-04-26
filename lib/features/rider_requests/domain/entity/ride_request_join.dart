import '../../../../shared/domain/entity/location_entity.dart';
import '../../../../shared/domain/entity/ratings.dart';
import '../../../cars/domain/entity/car.dart';

class RideRequestJoinEntity {
  final String id;
  final RideEntity ride;
  final RiderDetailsEntity riderDetails;

  RideRequestJoinEntity({
    required this.id,
    required this.ride,
    required this.riderDetails,
  });
}

class RideEntity {
  final Ratings ratings;
  final LocationEntity source;
  final LocationEntity destination;
  final DateTime date;
  final DateTime departureTime;
  final String driverName;
  final int noOfSeats;
  final int noOfOccupiedSeats;
  final CarEntity car;

  RideEntity({
    required this.ratings,
    required this.source,
    required this.destination,
    required this.date,
    required this.departureTime,
    required this.driverName,
    required this.noOfSeats,
    required this.noOfOccupiedSeats,
    required this.car,
  });
}

class RiderDetailsEntity {
  final double fare;
  final DateTime eta;

  RiderDetailsEntity({
    required this.fare,
    required this.eta,
  });
}
