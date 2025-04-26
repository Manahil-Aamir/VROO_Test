import 'package:equatable/equatable.dart';

abstract class RideRequestJoinEvent extends Equatable {
  const RideRequestJoinEvent();

  @override
  List<Object> get props => [];
}

class FetchPendingRideRequestJoins extends RideRequestJoinEvent {
  final String rideRequestId;

  const FetchPendingRideRequestJoins(this.rideRequestId);

  @override
  List<Object> get props => [rideRequestId];
}
