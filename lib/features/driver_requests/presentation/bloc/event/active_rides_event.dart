sealed class ActiveRidesEvent {}

class FetchActiveRides extends ActiveRidesEvent {
  final String driverId;
  FetchActiveRides(this.driverId);
}
