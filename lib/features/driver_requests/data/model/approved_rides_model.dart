import '../../domain/entity/approved_rides.dart';

class ApprovedRidesModel {
  final String riderId;
  final String status;
  final int fare;
  final String rideRequestId;
  final LocationModel source;
  final LocationModel destination;
  final DateTime date;
  final TimeRangeModel pickupTimeRange;
  final DateTime maxArrivalTime;

  ApprovedRidesModel({
    required this.riderId,
    required this.status,
    required this.fare,
    required this.rideRequestId,
    required this.source,
    required this.destination,
    required this.date,
    required this.pickupTimeRange,
    required this.maxArrivalTime,
  });

  factory ApprovedRidesModel.fromJson(Map<String, dynamic> json) {
    return ApprovedRidesModel(
      riderId: json['riderId'] ?? '',
      status: json['status'] ?? '',
      fare: json['fare']?.toInt() ?? 0,
      rideRequestId: json['rideRequestId'] ?? '',
      source: LocationModel.fromJson(json['source'] ?? {}),
      destination: LocationModel.fromJson(json['destination'] ?? {}),
      date: DateTime.parse(json['date']),
      pickupTimeRange: TimeRangeModel.fromJson(json['pickupTimeRange'] ?? {}),
      maxArrivalTime: DateTime.parse(json['maxArrivalTime']),
    );
  }

  ApprovedRidesEntity toEntity() {
    return ApprovedRidesEntity(
      riderId: riderId,
      status: status,
      fare: fare,
      rideRequestId: rideRequestId,
      source: source.toEntity(),
      destination: destination.toEntity(),
      date: date,
      pickupTimeRange: pickupTimeRange.toEntity(),
      maxArrivalTime: maxArrivalTime,
    );
  }
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
