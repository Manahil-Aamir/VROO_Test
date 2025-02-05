import '../repository/rides_details_repository.dart';

class ApproveRideRequest {
  final RideDetailsRepository repository;

  ApproveRideRequest(this.repository);

  Future<void> execute(String rideRequestId, String rideId) async {
    await repository.approveRideRequest(rideRequestId, rideId);
  }
}