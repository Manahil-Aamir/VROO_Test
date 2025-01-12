import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class DriverHomeState extends Equatable {
  const DriverHomeState();

  @override
  List<Object> get props => [];
}

class DriverHomeInitial extends DriverHomeState {}

class DriverHomeLoading extends DriverHomeState {}

class DriverHomeLoaded extends DriverHomeState {
  final LatLng location;

  const DriverHomeLoaded(this.location);

  @override
  List<Object> get props => [location];
}

class DriverHomeError extends DriverHomeState {
  final String message;

  const DriverHomeError(this.message);

  @override
  List<Object> get props => [message];
}
