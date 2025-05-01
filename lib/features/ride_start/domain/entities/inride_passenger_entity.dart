import 'package:vroo_test/features/ride_start/data/models/rider_model.dart';
import 'package:vroo_test/features/ride_start/domain/entities/rider_entity.dart';

class InridePassengerEntity {
  final String riderId;
  final String status;
  final double fare;
  final DateTime eta;
  final String rideRequestId;
  final RiderModel rideRequest;
  final String riderName;
  final String? review;
  final bool? sameSource;
  final bool? sameDestination;
  final String? fcmToken;

  InridePassengerEntity({
    required this.riderId,
    required this.status,
    required this.fare,
    required this.rideRequestId,
    required this.eta,
    required this.rideRequest,
    required this.riderName,
    this.review,
    this.sameSource,
    this.sameDestination,
    this.fcmToken,
  });
}
