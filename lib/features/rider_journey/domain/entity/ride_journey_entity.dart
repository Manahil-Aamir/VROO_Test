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
}

class RideLocation {
  final List<double> coords;
  final String placeId;
  final String address;

  const RideLocation({
    required this.coords,
    required this.placeId,
    required this.address,
  });
}

class PickupTimeRange {
  final String min;
  final String max;

  const PickupTimeRange({required this.min, required this.max});

}

class RidePreferences {
  final bool maleOnly;
  final bool femaleOnly;
  final bool canWalk;

  const RidePreferences({
    required this.maleOnly,
    required this.femaleOnly,
    required this.canWalk,
  });

}
