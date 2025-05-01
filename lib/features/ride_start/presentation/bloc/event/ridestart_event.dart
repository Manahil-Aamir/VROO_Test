// Events
import 'package:equatable/equatable.dart';

abstract class RideStartEvent extends Equatable {
  const RideStartEvent();

  @override
  List<Object?> get props => [];
}

class InitializeRideEvent extends RideStartEvent {
  final String rideId;

  const InitializeRideEvent(this.rideId);

  @override
  List<Object?> get props => [rideId];
}
