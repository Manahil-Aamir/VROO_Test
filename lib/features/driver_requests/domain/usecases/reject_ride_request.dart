import '../repository/pending_rides_repository.dart';

class RejectRideRequest {
  final PendingRidesRepository repository;

  RejectRideRequest(this.repository);

  Future<void> execute(String rideRequestId, String rideId) async {
    await repository.rejectRideRequest(rideRequestId, rideId);
  }
}