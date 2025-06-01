import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../authentication/data/model/user_model.dart';
import '../../../data/data_source/home_data_source.dart';
import '../../../data/models/ongoing_model.dart';
import '../../../data/models/review_check_model.dart';
import '../../../data/models/ride_check_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final LatLng location;
  const HomeLoaded(this.location);
  @override
  List<Object> get props => [location];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object> get props => [message];
}

class HomeLogoutSuccess extends HomeState {}

class UserLoadedState extends HomeState {
  final UserModel user;
  const UserLoadedState(this.user);
  @override
  List<Object> get props => [user];
}

class NoUserFoundState extends HomeState {}

// New states for the ongoing trip feature
class OngoingTripLoading extends HomeState {}

class OngoingTripLoaded extends HomeState {
  final OngoingModel trip;
  const OngoingTripLoaded(this.trip);
  @override
  List<Object> get props => [trip];
}

class NoOngoingTripState extends HomeState {}

class OngoingTripError extends HomeState {
  final String message;
  const OngoingTripError(this.message);
  @override
  List<Object> get props => [message];
}

// New states for review functionality
class ReviewLoading extends HomeState {}

class ReviewSuccess extends HomeState {
  final String message;
  const ReviewSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class ReviewError extends HomeState {
  final String message;
  const ReviewError(this.message);
  @override
  List<Object> get props => [message];
}

class RideCheckLoading extends HomeState {}

class RideCheckLoaded extends HomeState {
  final RideCheckModel rideData;
  const RideCheckLoaded(this.rideData);
  @override
  List<Object> get props => [rideData];
}

class RideCheckNotFound extends HomeState {
  final String message;
  const RideCheckNotFound(this.message);
  @override
  List<Object> get props => [message];
}

class RideCheckError extends HomeState {
  final String message;
  const RideCheckError(this.message);
  @override
  List<Object> get props => [message];
}
