// domain/entity/passenger_entity.dart
import '../../../../shared/domain/entity/location_entity.dart';
import '../../../cars/domain/entity/car.dart';

class PassengerEntity {
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

  PassengerEntity({
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
}

// domain/entity/ride_entity.dart
class RideEntity {
  final String id;
  final String driverId;
  final String driverName;
  final String date;
  final LocationEntity source;
  final LocationEntity destination;
  final String departureTime;
  final CarEntity car;
  final List<String> paymentMethod;
  final double fare;
  final List<PassengerEntity> passengers;
  final String expectedArrivalTime;

  RideEntity({
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
}

// domain/entity/ride_history_entity.dart
class DriverHistoryEntity {
  final List<RideEntity> completedRides;
  final List<RideEntity> cancelledRides;

  DriverHistoryEntity({
    required this.completedRides,
    required this.cancelledRides,
  });
}
