import '../../domain/entity/pending_rides.dart';
import '../../../rider_requests/data/models/driver_rider_detail_model.dart';
import 'location_modal.dart';
import 'preferences_modal.dart';
import 'time_range_model.dart';

class PendingRidesModel {
  final DateTime date;
  final LocationModel source;
  final LocationModel destination;
  final DateTime eta;
  final int fare;
  final TimeRangeModel pickupTimeRange;
  final PreferencesModel preferences;
  final RequestModel request;
  final DriverRiderDetailModel riderDetails;

  PendingRidesModel({
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

  factory PendingRidesModel.fromJson(Map<String, dynamic> json) {
    return PendingRidesModel(
      date: DateTime.parse(json['date']),
      source: LocationModel.fromJson(json['source'] ?? {}),
      destination: LocationModel.fromJson(json['destination'] ?? {}),
      eta: DateTime.parse(json['eta']),
      fare: json['fare']?.toInt() ?? 0,
      pickupTimeRange: TimeRangeModel.fromJson(json['pickupTimeRange'] ?? {}),
      preferences: PreferencesModel.fromJson(json['preferences'] ?? {}),
      request: RequestModel.fromJson(json['request'] ?? {}),
      riderDetails: DriverRiderDetailModel.fromJson(json['riderDetails'] ?? {}),
    );
  }

  PendingRidesEntity toEntity() => PendingRidesEntity(
        date: date,
        source: source.toEntity(),
        destination: destination.toEntity(),
        eta: eta,
        fare: fare,
        pickupTimeRange: pickupTimeRange.toEntity(),
        preferences: preferences.toEntity(),
        request: request.toEntity(),
        riderDetails: riderDetails.toEntity(),
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
      status: json['status'] ?? 'pending',
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


