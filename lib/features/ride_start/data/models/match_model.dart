import '../../domain/entities/match_entity.dart';

class MatchModel extends MatchEntity {
  MatchModel({
    required super.rideId,
    required super.detourDistance,
    required super.detourDuration,
    required super.fare,
    required super.eta,
    required super.sameSource,
  });

  Map<String, dynamic> toMap() {
    return {
      'rideId': rideId,
      'detourDistance': detourDistance,
      'detourDuration': detourDuration,
      'fare': fare,
      'eta': eta,
      'sameSource': sameSource,
    };
  }

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      rideId: map['rideId'] ?? '',
      detourDistance: map['detourDistance'] ?? 0,
      detourDuration: map['detourDuration'] ?? 0,
      fare: (map['fare'] as num?)?.toDouble() ?? 0.0,
      eta: (map['eta']) ?? '',
      sameSource: map['sameSource'] ?? false,
    );
  }
}
