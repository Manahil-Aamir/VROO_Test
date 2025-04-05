class ApprovedRidesEntity {
  final String riderId;
  final String status;
  final int fare;
  final String rideRequestId;
  final String source;          // Changed from Location to String
  final String destination;     // Changed from Location to String
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

class TimeRange {
  final DateTime min;
  final DateTime max;

  TimeRange({required this.min, required this.max});
}
