import 'package:equatable/equatable.dart';

abstract class DriverHomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class DriverHomeInitial extends DriverHomeState {}

class DriverHomeLoading extends DriverHomeState {}

class DriverHomePointSelected extends DriverHomeState {
  final String pointType;
  final String location;

  DriverHomePointSelected(this.pointType, this.location);

  @override
  List<Object> get props => [pointType, location];
}

class DriverHomeError extends DriverHomeState {
  final String message;

  DriverHomeError(this.message);

  @override
  List<Object> get props => [message];
}

class NavigateToLocationSelectionState extends DriverHomeState {}
