sealed class ApprovedRidesEvent {}

class FetchApprovedRides extends ApprovedRidesEvent {
  final String driverId;
  FetchApprovedRides(this.driverId);
}
