import 'package:equatable/equatable.dart';

import '../../../data/data_source/home_data_source.dart';
import '../../../data/models/review_check_model.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoadCurrentLocationEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class ClearPreferencesEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class LogoutEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class LoadUserEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

// New event for the ongoing trip feature
class CheckOngoingTripEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

// New events for review functionality
class GiveReviewEvent extends HomeEvent {
  final ReviewModel reviewRequest;

  const GiveReviewEvent(this.reviewRequest);

  @override
  List<Object> get props => [reviewRequest];
}

class CheckRideEvent extends HomeEvent {
  final String rideId;

  const CheckRideEvent(this.rideId);

  @override
  List<Object> get props => [rideId];
}
