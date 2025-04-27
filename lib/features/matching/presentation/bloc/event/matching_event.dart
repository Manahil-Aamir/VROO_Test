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
  final String id;
  const ModifyTimeWindowEvent({required this.id, required this.modifyData});

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

class FetchRideRequestMatchesEvent extends MatchingEvent {
  final String rideRequestId;
  const FetchRideRequestMatchesEvent({required this.rideRequestId});

  @override
  List<Object> get props => [rideRequestId];
}

// In matching_event.dart
class ToggleMatchesVisibility extends MatchingEvent {
  final bool showMatches;

  const ToggleMatchesVisibility({required this.showMatches});

  @override
  List<Object> get props => [showMatches];
}


