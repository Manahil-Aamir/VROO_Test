import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../authentication/data/model/user_model.dart';

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
