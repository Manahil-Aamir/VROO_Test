import '../entity/ride_request_join.dart';

abstract class RideRequestJoinRepository {
  Future<List<RideRequestJoinEntity>> getPendingRideRequestJoins(String rideRequestId);
}
