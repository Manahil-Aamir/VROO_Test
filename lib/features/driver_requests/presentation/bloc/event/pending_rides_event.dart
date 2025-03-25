sealed class PendingRidesEvent {}

class FetchPendingRides extends PendingRidesEvent {
  final String driverId;
  FetchPendingRides(this.driverId);
}

class ApproveRideRequestEvent extends PendingRidesEvent {
  final String rideRequestId;
  final String rideId;

  ApproveRideRequestEvent({
    required this.rideRequestId,
    required this.rideId,
  });
}

class RejectRideRequestEvent extends PendingRidesEvent {
  final String rideRequestId;
  final String rideId;

  RejectRideRequestEvent({
    required this.rideRequestId,
    required this.rideId,
  });
}
