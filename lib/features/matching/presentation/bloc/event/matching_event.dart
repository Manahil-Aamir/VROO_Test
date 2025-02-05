// r3_event.dart
import 'package:equatable/equatable.dart';

abstract class MatchingEvent extends Equatable {
  const MatchingEvent();

  @override
  List<Object> get props => [];
}

/// Event to modify the time window.
/// The [modifyData] map should contain the parameters needed by the use case (e.g. 'rideRequestId' and 'timeWindow').
class ModifyTimeWindowEvent extends MatchingEvent {
  final Map<String, dynamic> modifyData;
  const ModifyTimeWindowEvent({required this.modifyData});

  @override
  List<Object> get props => [modifyData];
}

/// Event to join a ride.
/// The [joinData] map should be of type Map<String, String> and contain the parameters required (e.g. 'rideId').
class JoinRideRequestEvent extends MatchingEvent {
  final Map<String, String> joinData;
  const JoinRideRequestEvent({required this.joinData});

  @override
  List<Object> get props => [joinData];
}
