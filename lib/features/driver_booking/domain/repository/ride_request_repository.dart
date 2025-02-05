import '../entity/ride_request.dart';

abstract class RideRepository {
  Future<void> submitRideRequest(RideRequest request);
}