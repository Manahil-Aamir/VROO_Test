import '../../../cars/domain/entity/car.dart';
import '../../../rider_journey/domain/entity/ride_journey_entity.dart';

class MatchingRide {
  final String id;
  final CarEntity car;
  final String date;
  final String departureTime;
  final RideLocation source;
  final RideLocation destination;
  final double distance;
  final String driverId;
  final String driverName;
  final String driverGender;
  final double duration;
  final EnvironmentStats environmentStats;
  final String expectedArrivalTime;
  final double fare;
  final bool isRecurring;
  final String maxArrivalTime;
  final List<String> neighbourRouteCells;
  final double numOfSeats;
  final List<Passenger> passengers;
  final List<dynamic> paymentMethod;
  final RidePreferences preferences;
  //final List<dynamic> recurringRides;
  final List<dynamic> routeCells;
  final List<dynamic> routeCoords;
  final String status;
  final double totalDetourDistance;
  final double totalDetourDuration;

  const MatchingRide({
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
    //required this.recurringRides,
    required this.routeCells,
    required this.routeCoords,
    required this.status,
    required this.totalDetourDistance,
    required this.totalDetourDuration,
  });
}

class EnvironmentStats {
  final double co2Saved;
  final double fuelSaved;

  const EnvironmentStats({required this.co2Saved, required this.fuelSaved});
}

class Passenger {
  final String eta;
  final double fare;
  final String rideRequestId;
  final String riderId;
  final String status;

  const Passenger({
    required this.eta,
    required this.fare,
    required this.rideRequestId,
    required this.riderId,
    required this.status,
  });
}

class RideResponse {
  final String message;
  final String rideRequestId;
  final List<MatchingRide> matchingRides;

  const RideResponse({
    required this.message,
    required this.rideRequestId,
    required this.matchingRides,
  });
}
