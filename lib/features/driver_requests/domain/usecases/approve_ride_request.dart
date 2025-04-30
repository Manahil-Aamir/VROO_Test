import '../repository/pending_rides_repository.dart';

class ApproveRideRequest {
  final PendingRidesRepository repository;

  ApproveRideRequest(this.repository);

  Future<void> execute(String rideRequestId, String rideId) async {
    print("Approving ride request with ID: $rideRequestId for ride ID: $rideId");
    await repository.approveRideRequest(rideRequestId, rideId);
  }
}
