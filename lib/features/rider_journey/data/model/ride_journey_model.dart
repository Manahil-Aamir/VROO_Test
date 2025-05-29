class RiderJourneyModel {
  final String riderId;
  final RideLocationModel source;
  final RideLocationModel destination;
  final String date;
  final PickupTimeRangeModel pickupTimeRange;
  final String maxArrivalTime;
  final RidePreferencesModel preferences;
  final bool isRecurring;
  final String? frequency;
  final Set<String>? selectedDays;
  final DateTime? endDate;

  const RiderJourneyModel({
    required this.riderId,
    required this.source,
    required this.destination,
    required this.date,
    required this.pickupTimeRange,
    required this.maxArrivalTime,
    required this.preferences,
    required this.isRecurring,
    this.frequency,
    this.selectedDays,
    this.endDate,
  });

  factory RiderJourneyModel.fromJson(Map<String, dynamic> json) {
    return RiderJourneyModel(
      riderId: json['riderId'],
      source: RideLocationModel.fromJson(json['source']),
      destination: RideLocationModel.fromJson(json['destination']),
      date: json['date'],
      pickupTimeRange: PickupTimeRangeModel.fromJson(json['pickupTimeRange']),
      maxArrivalTime: json['maxArrivalTime'],
      preferences: RidePreferencesModel.fromJson(json['preferences']),
      isRecurring: json['isRecurring'],
      frequency: json['frequency'] ?? null,
      selectedDays: json['customDays'] ?? null,
      endDate: json['endsOn'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'riderId': riderId,
      'source': source.toJson(),
      'destination': destination.toJson(),
      'date': date,
      'pickupTimeRange': pickupTimeRange.toJson(),
      'maxArrivalTime': maxArrivalTime,
      'preferences': preferences.toJson(),
      'isRecurring': isRecurring,
      'frequency': frequency,
      // FIX: Convert Set to List for JSON serialization
      'customDays': (selectedDays?.isNotEmpty ?? false) ? selectedDays!.toList() : [],
      'endsOn': endDate?.toIso8601String(),
    };
  }
}

class RideLocationModel {
  final List<double> coords;
  final String placeId;
  final String address;

  const RideLocationModel({
    required this.coords,
    required this.placeId,
    required this.address,
  });

  factory RideLocationModel.fromJson(Map<String, dynamic> json) {
    return RideLocationModel(
      coords: List<double>.from(json['coords'].map((e) => e.toDouble())),
      placeId: json['placeId'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coords': coords,
      'placeId': placeId,
      'address': address,
    };
  }
}

class PickupTimeRangeModel {
  final String min;
  final String max;

  const PickupTimeRangeModel({
    required this.min,
    required this.max,
  });

  factory PickupTimeRangeModel.fromJson(Map<String, dynamic> json) {
    return PickupTimeRangeModel(
      min: json['min'],
      max: json['max'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}

class RidePreferencesModel {
  final bool maleOnly;
  final bool femaleOnly;
  final bool? canWalk;

  const RidePreferencesModel({
    required this.maleOnly,
    required this.femaleOnly,
    this.canWalk,
  });

  factory RidePreferencesModel.fromJson(Map<String, dynamic> json) {
    return RidePreferencesModel(
      maleOnly: json['maleOnly'],
      femaleOnly: json['femaleOnly'],
      canWalk: json.containsKey('canWalk') ? json['canWalk'] as bool? : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maleOnly': maleOnly,
      'femaleOnly': femaleOnly,
      if (canWalk != null) 'canWalk': canWalk,
    };
  }
}
