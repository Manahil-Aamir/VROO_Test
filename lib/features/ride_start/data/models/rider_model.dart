import 'package:vroo_test/features/ride_start/data/models/match_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/ride_journey_model.dart';
import '../../domain/entities/rider_entity.dart';
import 'address_model.dart';

class RiderModel extends RiderEntity {
  RiderModel({
    required super.id,
    required super.riderId,
    required super.source,
    required super.destination,
    required super.date,
    required super.duration,
    required super.distance,
    required super.pickupTimeRange,
    required super.maxArrivalTime,
    required super.preferences,
    required super.isRecurring,
    required super.status,
    required super.matches,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'riderId': riderId,
      'source': source.toString(),
      'destination': destination.toMap(),
      'date': date,
      'duration': duration,
      'distance': distance,
      'pickupTimeRange': pickupTimeRange.toMap(),
      'maxArrivalTime': maxArrivalTime,
      'preferences': preferences.toMap(),
      'isRecurring': isRecurring,
      'status': status,
      'matches': matches.map((m) => m.toMap()).toList(),
    };
  }

  factory RiderModel.fromMap(Map<String, dynamic> map) {
    return RiderModel(
      id: map['_id'] ?? '',
      riderId: map['riderId'] ?? '',
      source: AddressModel.fromMap(map['source']),
      destination: AddressModel.fromMap(map['destination']),
      date: DateTime.parse(map['date']),
      duration: map['duration'].toDouble() ?? 0,
      distance: map['distance'].toDouble() ?? 0,
      pickupTimeRange: PickupTimeRangeModel.fromMap(map['pickupTimeRange']),
      maxArrivalTime: DateTime.parse(map['maxArrivalTime']),
      preferences: RidePreferencesModel.fromMap(map['preferences']),
      isRecurring: map['isRecurring'] ?? false,
      status: map['status'] ?? '',
      matches: List<MatchModel>.from(
          map['matches'].map((x) => MatchModel.fromMap(x))),
    );
  }
}
