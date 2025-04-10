class ApprovedRidesEntity {
  final String riderId;
  final String riderName;      
  final String status;
  final int fare;
  final String rideRequestId;
  final String source;          // Changed from Location to String
  final String destination;     // Changed from Location to String
  final DateTime date;
  final TimeRange pickupTimeRange;
  final DateTime maxArrivalTime;
  final Ratings ratings; // Added ratings field

  ApprovedRidesEntity({
    required this.riderId,
    required this.riderName,
    required this.status,
    required this.fare,
    required this.rideRequestId,
    required this.source,
    required this.destination,
    required this.date,
    required this.pickupTimeRange,
    required this.maxArrivalTime,
    required this.ratings,
  });
}

class TimeRange {
  final DateTime min;
  final DateTime max;

  TimeRange({required this.min, required this.max});
}

class Ratings {
  final int asDriver;
  final int asRider;

  Ratings({
    required this.asDriver,
    required this.asRider,
  });
}
