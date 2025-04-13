abstract class ActiveRidesDriverEvent {}

class FetchActiveRidesDriver extends ActiveRidesDriverEvent {
  // final String driverId;

  // FetchActiveRidesDriver(this.driverId);
}

class FilterRidesByDate extends ActiveRidesDriverEvent {
  final DateTime? selectedDate;

  FilterRidesByDate(this.selectedDate);
}

class ClearDateFilter extends ActiveRidesDriverEvent {}

class CancelRideEvent extends ActiveRidesDriverEvent {
  final String rideId;

  CancelRideEvent(this.rideId);
}

class ClearErrorEvent extends ActiveRidesDriverEvent {}
