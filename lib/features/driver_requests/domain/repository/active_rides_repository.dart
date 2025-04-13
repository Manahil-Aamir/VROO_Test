import 'package:vroo_test/features/driver_requests/domain/entity/active_ride.dart';

abstract class ActiveRidesRepository {
  Future<List<ActiveRideEntity>> getActiveRides();
  Future<void> cancelRide(String rideId);
}
