import '../repository/pending_rides_repository.dart';

class ApproveRideRequest {
  final PendingRidesRepository repository;

  ApproveRideRequest(this.repository);

  Future<void> execute(String rideRequestId, String rideId) async {
    await repository.approveRideRequest(rideRequestId, rideId);
  }
}
