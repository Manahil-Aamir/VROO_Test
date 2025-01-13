import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class RiderHomeState extends Equatable {
  const RiderHomeState();

  @override
  List<Object> get props => [];
}

class RiderHomeInitial extends RiderHomeState {}

class RiderHomeLoading extends RiderHomeState {}

class RiderHomeLoaded extends RiderHomeState {
  final LatLng location;

  const RiderHomeLoaded(this.location);

  @override
  List<Object> get props => [location];
}

class RiderHomeError extends RiderHomeState {
  final String message;

  const RiderHomeError(this.message);

  @override
  List<Object> get props => [message];
}
