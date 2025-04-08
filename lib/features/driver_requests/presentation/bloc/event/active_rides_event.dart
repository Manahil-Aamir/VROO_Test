abstract class ActiveRidesEvent {}

class FetchActiveRides extends ActiveRidesEvent {
  final String driverId;

  FetchActiveRides(this.driverId);
}

class FilterRidesByDate extends ActiveRidesEvent {
  final DateTime? selectedDate;

  FilterRidesByDate(this.selectedDate);
}

class ClearDateFilter extends ActiveRidesEvent {}
