import '../entity/pending_rides.dart';

abstract class PendingRidesRepository {
  Future<List<PendingRidesEntity>> getPendingRides(String rideId);
  Future<void> approveRideRequest(String rideRequestId, String rideId);
}
