import 'package:vroo_test/features/ride_start/data/models/rider_model.dart';

class InridePassengerEntity {
  final String riderId;
  final String status;
  final double fare;
  final String rideRequestId;
  final DateTime? eta;
  final RiderModel rideRequest;
  final String riderName;
  final String? review;
  final bool? sameSource;
  final bool? sameDestination;
  final String? fcmToken;
  final double? detourDistance;
  final double? detourDuration;

  InridePassengerEntity({
    required this.riderId,
    required this.status,
    required this.fare,
    required this.rideRequestId,
    this.eta,
    required this.rideRequest,
    required this.riderName,
    this.review,
    this.sameSource,
    this.sameDestination,
    this.fcmToken,
    this.detourDistance,
    this.detourDuration,
  });
}
