import 'package:equatable/equatable.dart';

class RiderJourneyEntity {
  final String riderId;
  final RideLocation source;
  final RideLocation destination;
  final String date;
  final PickupTimeRange pickupTimeRange;
  final String maxArrivalTime;
  final RidePreferences preferences;
  final bool isRecurring;

  const RiderJourneyEntity({
    required this.riderId,
    required this.source,
    required this.destination,
    required this.date,
    required this.pickupTimeRange,
    required this.maxArrivalTime,
    required this.preferences,
    required this.isRecurring,
  });

  @override
  List<Object> get props => [
        riderId,
        source,
        destination,
        date,
        pickupTimeRange,
        maxArrivalTime,
        preferences,
        isRecurring,
      ];
}

class RideLocation extends Equatable {
  final List<double> coords;
  final String placeId;
  final String address;

  const RideLocation({
    required this.coords,
    required this.placeId,
    required this.address,
  });

  @override
  List<Object> get props => [coords, placeId, address];
}

class PickupTimeRange extends Equatable {
  final String min;
  final String max;

  const PickupTimeRange({required this.min, required this.max});

  @override
  List<Object> get props => [min, max];
}

class RidePreferences extends Equatable {
  final bool maleOnly;
  final bool femaleOnly;
  final bool canWalk;

  const RidePreferences({
    required this.maleOnly,
    required this.femaleOnly,
    required this.canWalk,
  });

  @override
  List<Object> get props => [maleOnly, femaleOnly, canWalk];
}
