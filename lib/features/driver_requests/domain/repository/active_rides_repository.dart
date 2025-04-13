import 'package:vroo_test/features/driver_requests/domain/entity/active_ride.dart';

abstract class ActiveRidesDriverRepository {
  Future<List<ActiveRideEntity>> getActiveRidesDriver();
  Future<void> cancelRide(String rideId);
}
