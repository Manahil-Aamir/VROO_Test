// passenger_data_entity.dart
import 'package:equatable/equatable.dart';
import 'package:vroo_test/features/ride_start/domain/entities/address_entity.dart';

class RidingPassengerEntity extends Equatable {
  final String? review;
  final String? riderId;
  final String status;
  final String rideRequestId;
  final double fare;
  final DateTime eta;
  final bool sameSource;
  final bool sameDestination;
  final String gender;
  final int detourDistance;
  final int detourDuration;
  final String username;
  final Address source;
  final Address destination;

  const RidingPassengerEntity({
    this.review,
    this.riderId,
    required this.status,
    required this.rideRequestId,
    required this.fare,
    required this.eta,
    required this.sameSource,
    required this.sameDestination,
    required this.gender,
    required this.detourDistance,
    required this.detourDuration,
    required this.username,
    required this.source,
    required this.destination,
  });

  @override
  List<Object?> get props => [
        review,
        riderId,
        status,
        rideRequestId,
        fare,
        eta,
        sameSource,
        sameDestination,
        gender,
        detourDistance,
        detourDuration,
        username,
        source,
        destination,
      ];
}
