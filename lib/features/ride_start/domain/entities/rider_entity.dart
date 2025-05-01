import 'package:vroo_test/features/ride_start/data/models/address_model.dart';
import 'package:vroo_test/features/ride_start/data/models/match_model.dart';
import 'package:vroo_test/features/ride_start/domain/entities/address_entity.dart';
import 'package:vroo_test/features/rider_journey/data/model/ride_journey_model.dart';

import '../../../rider_journey/domain/entity/ride_journey_entity.dart';

class RiderEntity {
  final String id;
  final String riderId;
  final AddressModel source;
  final AddressModel destination;
  final DateTime date;
  final double duration;
  final double distance;
  final PickupTimeRangeModel pickupTimeRange;
  final DateTime maxArrivalTime;
  final RidePreferencesModel preferences;
  final bool isRecurring;
  final String status;
  final List<MatchModel> matches;

  RiderEntity({
    required this.id,
    required this.riderId,
    required this.source,
    required this.destination,
    required this.date,
    required this.duration,
    required this.distance,
    required this.pickupTimeRange,
    required this.maxArrivalTime,
    required this.preferences,
    required this.isRecurring,
    required this.status,
    required this.matches,
  });
}
