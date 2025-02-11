import '../../domain/entity/ride_journey_entity.dart';

class RiderJourneyModel extends RiderJourneyEntity {
  const RiderJourneyModel({
    required super.riderId,
    required super.source,
    required super.destination,
    required super.date,
    required super.pickupTimeRange,
    required super.maxArrivalTime,
    required super.preferences,
    required super.isRecurring,
  });

  factory RiderJourneyModel.fromMap(Map<String, dynamic> map) {
    return RiderJourneyModel(
      riderId: map['riderId'],
      source: RideLocationModel.fromMap(map['source']),
      destination: RideLocationModel.fromMap(map['destination']),
      date: map['date'],
      pickupTimeRange: PickupTimeRangeModel.fromMap(map['pickupTimeRange']),
      maxArrivalTime: map['maxArrivalTime'],
      preferences: RidePreferencesModel.fromMap(map['preferences']),
      isRecurring: map['isRecurring'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'riderId': riderId,
      'source': (source as RideLocationModel).toMap(),
      'destination': (destination as RideLocationModel).toMap(),
      'date': date,
      'pickupTimeRange': (pickupTimeRange as PickupTimeRangeModel).toMap(),
      'maxArrivalTime': maxArrivalTime,
      'preferences': (preferences as RidePreferencesModel).toMap(),
      'isRecurring': isRecurring,
    };
  }
}

class RideLocationModel extends RideLocation {
  const RideLocationModel({
    required super.coords,
    required super.placeId,
    required super.address,
  });

  factory RideLocationModel.fromMap(Map<String, dynamic> map) {
    return RideLocationModel(
      coords: List<double>.from(map['coords']),
      placeId: map['placeId'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coords': coords,
      'placeId': placeId,
      'address': address,
    };
  }
}

class PickupTimeRangeModel extends PickupTimeRange {
  const PickupTimeRangeModel({required super.min, required super.max});

  factory PickupTimeRangeModel.fromMap(Map<String, dynamic> map) {
    return PickupTimeRangeModel(
      min: map['min'],
      max: map['max'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'min': min,
      'max': max,
    };
  }
}

class RidePreferencesModel extends RidePreferences {
  const RidePreferencesModel({
    required super.maleOnly,
    required super.femaleOnly,
    required super.canWalk,
  });

  factory RidePreferencesModel.fromMap(Map<String, dynamic> map) {
    return RidePreferencesModel(
      maleOnly: map['maleOnly'] ?? false,
      femaleOnly: map['femaleOnly'] ?? false,
      canWalk: map['canWalk'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'maleOnly': maleOnly,
      'femaleOnly': femaleOnly,
      'canWalk': canWalk,
    };
  }
}
