import 'package:equatable/equatable.dart';

class OngoingEntity extends Equatable {
  final String mode;
  final String rideId;

  const OngoingEntity({
    required this.mode,
    required this.rideId,
  });

  @override
  List<Object> get props => [mode, rideId];
}
