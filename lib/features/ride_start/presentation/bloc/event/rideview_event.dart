import 'package:equatable/equatable.dart';

abstract class RideViewEvent extends Equatable {
  const RideViewEvent();

  @override
  List<Object?> get props => [];
}

class InitializeRideViewEvent extends RideViewEvent {
  final String rideId;

  const InitializeRideViewEvent(this.rideId);

  @override
  List<Object?> get props => [rideId];
}
