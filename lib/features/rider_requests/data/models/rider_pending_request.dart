import 'package:vroo_test/features/rider_requests/domain/entity/rider_pending_request_entity.dart';

import '../../../../shared/data/models/location_modal.dart';
import '../../../../shared/data/models/preferences_modal.dart';
import '../../../../shared/data/models/time_range_model.dart';

class RiderPendingRequestModel extends RiderPendingRequest {
  RiderPendingRequestModel({
    required super.id,
    required super.source,
    required super.destination,
    required super.date,
    required super.duration,
    required super.distance,
    required super.pickupTimeRange,
    required super.maxArrivalTime,
    required super.preferences,
    required super.numOfPassengers,
  });

  factory RiderPendingRequestModel.fromJson(Map<String, dynamic> json) {
    return RiderPendingRequestModel(
      id: json['_id'],
      source: LocationModel.fromJson(json['source']).toEntity(),
      destination: LocationModel.fromJson(json['destination']).toEntity(),
      date: DateTime.parse(json['date']),
      duration: json['duration'],
      distance: json['distance'],
      pickupTimeRange: TimeRangeModel.fromJson(json['pickupTimeRange']).toEntity(),
      maxArrivalTime: DateTime.parse(json['maxArrivalTime']),
      preferences: PreferencesModel.fromJson(json['preferences']).toEntity(),
      numOfPassengers: json['numOfPassengers'],
    );
  }

  // toEntity()
  RiderPendingRequest toEntity() {
    return RiderPendingRequest(
      id: id,
      source: source,
      destination: destination,
      date: date,
      duration: duration,
      distance: distance,
      pickupTimeRange: pickupTimeRange,
      maxArrivalTime: maxArrivalTime,
      preferences: preferences,
      numOfPassengers: numOfPassengers,
    );
  }
}
