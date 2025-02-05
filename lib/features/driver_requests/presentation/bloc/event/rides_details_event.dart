sealed class RideDetailsEvent {}

class FetchRideDetails extends RideDetailsEvent {
  final String driverId;
  FetchRideDetails(this.driverId);
}
