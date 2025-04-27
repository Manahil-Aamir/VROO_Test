import 'package:equatable/equatable.dart';
import 'package:vroo_test/features/matching/data/models/matching_rides_model.dart';

abstract class MatchingState extends Equatable {
  const MatchingState();

  @override
  List<Object> get props => [];
}

/// Initial state that holds a time window and matching rides.
class RiderRequestInitial extends MatchingState {
  final int timeWindow;
  final List<dynamic> matchingRides;

  const RiderRequestInitial({
    required this.timeWindow,
    required this.matchingRides,
  });

  @override
  List<Object> get props => [timeWindow, matchingRides];
}

/// State while a modification is being processed.
class RiderRequestLoading extends MatchingState {}

/// State after a successful time window modification, with updated rides.
class RiderRequestLoaded extends MatchingState {
  //final int timeWindow;
  final List<MatchingRideModel> matchingRides;

  const RiderRequestLoaded({
    //required this.timeWindow,
    required this.matchingRides,
  });

  @override
  List<Object> get props => [matchingRides];
}

/// State while processing a join request.
class RiderJoinLoading extends MatchingState {}

/// State when joining a ride succeeds.
class RiderJoinSuccess extends MatchingState {
  final Map<String, dynamic> rideDetails;

  const RiderJoinSuccess(this.rideDetails);

  @override
  List<Object> get props => [rideDetails];
}

/// Generic error state.
class RiderRequestError extends MatchingState {
  final String error;
  const RiderRequestError(this.error);

  @override
  List<Object> get props => [error];
}

class RideRequestMatchesLoaded extends MatchingState {
  final List<MatchingRideModel> matches;

  const RideRequestMatchesLoaded({required this.matches});

  @override
  List<Object> get props => [matches];
}

// In matching_state.dart
class MatchesLoading extends MatchingState {}

class MatchesVisibilityToggled extends MatchingState {
  final bool showMatches;
  final List<MatchingRideModel> matches;

  const MatchesVisibilityToggled({
    required this.showMatches,
    required this.matches,
  });

  @override
  List<Object> get props => [showMatches, matches];
}
