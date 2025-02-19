class PendingRidesEntity {
  final DateTime date;
  final Location source;
  final Location destination;
  final DateTime eta;
  final int fare;
  final TimeRange pickupTimeRange;
  final Preferences preferences;
  final Request request;

  PendingRidesEntity({
    required this.date,
    required this.source,
    required this.destination,
    required this.eta,
    required this.fare,
    required this.pickupTimeRange,
    required this.preferences,
    required this.request,
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

class Preferences {
  final bool canWalk;
  final bool femaleOnly;
  final bool maleOnly;

  Preferences({
    required this.canWalk,
    required this.femaleOnly,
    required this.maleOnly,
  });
}

class Request {
  final String id;
  final String createdAt;
  final String driverId;
  final String rideId;
  final String rideRequestId;
  final String riderId;
  final String status;

  Request({
    required this.id,
    required this.createdAt,
    required this.driverId,
    required this.rideId,
    required this.rideRequestId,
    required this.riderId,
    required this.status,
  });
}
