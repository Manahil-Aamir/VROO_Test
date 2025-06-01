// domain/entity/rider_history/rider_entity.dart
import '../../../../shared/domain/entity/location_entity.dart';
import '../../../cars/domain/entity/car.dart';

class RiderEntity {
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
  final LocationEntity source;
  final LocationEntity destination;
  final Map<String, String> pickupTimeRange;

  RiderEntity({
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
}

// domain/entity/rider_history/rider_ride_entity.dart
class RiderRideEntity {
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
  final String expectedArrivalTime;
  final List<String> passengersName;
  final RiderEntity rider;

  RiderRideEntity({
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
}

// domain/entity/rider_history/rider_history_entity.dart
class RiderHistoryEntity {
  final List<RiderRideEntity> completedRides;
  final List<RiderRideEntity> cancelledRides;

  RiderHistoryEntity({
    required this.completedRides,
    required this.cancelledRides,
  });
}
