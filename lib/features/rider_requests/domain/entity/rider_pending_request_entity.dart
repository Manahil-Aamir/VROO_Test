import '../../../driver_requests/domain/entity/location_entity.dart';
import '../../../driver_requests/domain/entity/preferences.dart';
import '../../../driver_requests/domain/entity/time_range.dart';

class RiderPendingRequest {
  final String id;
  final LocationEntity source;
  final LocationEntity destination;
  final DateTime date;
  final int duration;
  final int distance;
  final TimeRange pickupTimeRange;
  final DateTime maxArrivalTime;
  final Preferences preferences;
  final int numOfPassengers;

  RiderPendingRequest({
    required this.id,
    required this.source,
    required this.destination,
    required this.date,
    required this.duration,
    required this.distance,
    required this.pickupTimeRange,
    required this.maxArrivalTime,
    required this.preferences,
    required this.numOfPassengers,
  });
}