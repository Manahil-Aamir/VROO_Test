import 'package:vroo_test/features/driver_requests/domain/entity/location_entity.dart';

import '../../../rider_requests/domain/entity/driver_rider_detail.dart';
import 'preferences.dart';
import 'time_range.dart';

class PendingRidesEntity {
  final DateTime date;
  final LocationEntity source;
  final LocationEntity destination;
  final DateTime eta;
  final int fare;
  final TimeRange pickupTimeRange;
  final Preferences preferences;
  final Request request;
  final DriverRiderDetail riderDetails;

  PendingRidesEntity({
    required this.date,
    required this.source,
    required this.destination,
    required this.eta,
    required this.fare,
    required this.pickupTimeRange,
    required this.preferences,
    required this.request,
    required this.riderDetails,
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


