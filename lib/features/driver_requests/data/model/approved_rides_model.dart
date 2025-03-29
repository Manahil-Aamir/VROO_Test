import '../../domain/entity/approved_rides.dart';

class ApprovedRidesModel {
  final DateTime date;
  final LocationModel source;
  final LocationModel destination;
  final DateTime eta;
  final int fare;
  final TimeRangeModel pickupTimeRange;
  final PreferencesModel preferences;
  final RequestModel request;

  ApprovedRidesModel({
    required this.date,
    required this.source,
    required this.destination,
    required this.eta,
    required this.fare,
    required this.pickupTimeRange,
    required this.preferences,
    required this.request,
  });

  factory ApprovedRidesModel.fromJson(Map<String, dynamic> json) {
    return ApprovedRidesModel(
      date: DateTime.parse(json['date']),
      source: LocationModel.fromJson(json['source'] ?? {}),
      destination: LocationModel.fromJson(json['destination'] ?? {}),
      eta: DateTime.parse(json['eta']),
      fare: json['fare']?.toInt() ?? 0,
      pickupTimeRange: TimeRangeModel.fromJson(json['pickupTimeRange'] ?? {}),
      preferences: PreferencesModel.fromJson(json['preferences'] ?? {}),
      request: RequestModel.fromJson(json['request'] ?? {}),
    );
  }

  ApprovedRidesEntity toEntity() => ApprovedRidesEntity(
        date: date,
        source: source.toEntity(),
        destination: destination.toEntity(),
        eta: eta,
        fare: fare,
        pickupTimeRange: pickupTimeRange.toEntity(),
        preferences: preferences.toEntity(),
        request: request.toEntity(),
      );
}

class LocationModel {
  final String address;
  final String cellId;
  final List<double> coords;
  final String placeId;

  LocationModel({
    required this.address,
    required this.cellId,
    required this.coords,
    required this.placeId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json['address'] ?? 'Unknown address',
      cellId: json['cellId'] ?? '',
      coords: List<double>.from((json['coords'] ?? []).map((x) => x.toDouble())),
      placeId: json['placeId'] ?? '',
    );
  }

  Location toEntity() => Location(
        address: address,
        cellId: cellId,
        coords: coords,
        placeId: placeId,
      );
}

class TimeRangeModel {
  final DateTime min;
  final DateTime max;

  TimeRangeModel({
    required this.min,
    required this.max,
  });

  factory TimeRangeModel.fromJson(Map<String, dynamic> json) {
    return TimeRangeModel(
      min: DateTime.parse(json['min']),
      max: DateTime.parse(json['max']),
    );
  }

  TimeRange toEntity() => TimeRange(
        min: min,
        max: max,
      );
}

class PreferencesModel {
  final bool canWalk;
  final bool femaleOnly;
  final bool maleOnly;

  PreferencesModel({
    required this.canWalk,
    required this.femaleOnly,
    required this.maleOnly,
  });

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      canWalk: json['canWalk'] ?? false,
      femaleOnly: json['femaleOnly'] ?? false,
      maleOnly: json['maleOnly'] ?? false,
    );
  }

  Preferences toEntity() => Preferences(
        canWalk: canWalk,
        femaleOnly: femaleOnly,
        maleOnly: maleOnly,
      );
}

class RequestModel {
  final String id;
  final String createdAt;
  final String driverId;
  final String rideId;
  final String rideRequestId;
  final String riderId;
  final String status;

  RequestModel({
    required this.id,
    required this.createdAt,
    required this.driverId,
    required this.rideId,
    required this.rideRequestId,
    required this.riderId,
    required this.status,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      driverId: json['driverId'] ?? '',
      rideId: json['rideId'] ?? '',
      rideRequestId: json['rideRequestId'] ?? '',
      riderId: json['riderId'] ?? '',
      status: json['status'] ?? 'approved',
    );
  }

  Request toEntity() => Request(
        id: id,
        createdAt: createdAt,
        driverId: driverId,
        rideId: rideId,
        rideRequestId: rideRequestId,
        riderId: riderId,
        status: status,
      );
}
