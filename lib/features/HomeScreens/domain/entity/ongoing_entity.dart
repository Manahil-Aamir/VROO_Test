import 'package:equatable/equatable.dart';

class OngoingEntity extends Equatable {
  final String role;
  final String rideId;

  const OngoingEntity({
    required this.role,
    required this.rideId,
  });

  @override
  List<Object> get props => [role, rideId];
}
