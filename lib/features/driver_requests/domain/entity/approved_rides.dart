class ApprovedRidesEntity {
  final String riderId;
  final String status;
  final int fare;
  final String rideRequestId;
  final Location source;
  final Location destination;
  final DateTime date;
  final TimeRange pickupTimeRange;
  final DateTime maxArrivalTime;

  ApprovedRidesEntity({
    required this.riderId,
    required this.status,
    required this.fare,
    required this.rideRequestId,
    required this.source,
    required this.destination,
    required this.date,
    required this.pickupTimeRange,
    required this.maxArrivalTime,
  });
}

class Location {
  final String address;
  final String cellId;
  final List<double> coords;
  final String placeId;

  Location({
    required this.address,
    required this.cellId,
    required this.coords,
    required this.placeId,
  });
}

class TimeRange {
  final DateTime min;
  final DateTime max;

  TimeRange({required this.min, required this.max});
}
