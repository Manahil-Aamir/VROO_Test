sealed class RideDetailsEvent {}

class FetchRideDetails extends RideDetailsEvent {
  final String driverId;
  FetchRideDetails(this.driverId);
}

class ApproveRideRequestEvent extends RideDetailsEvent {
  final String rideRequestId;
  final String rideId;

  ApproveRideRequestEvent({
    required this.rideRequestId,
    required this.rideId,
  });
}
