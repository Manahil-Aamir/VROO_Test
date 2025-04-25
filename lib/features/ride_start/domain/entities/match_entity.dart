class MatchEntity {
  final String rideId;
  final double detourDistance;
  final double detourDuration;
  final double fare;
  final DateTime eta;
  final bool sameSource;

  MatchEntity({
    required this.rideId,
    required this.detourDistance,
    required this.detourDuration,
    required this.fare,
    required this.eta,
    required this.sameSource,
  });
}
