import 'package:equatable/equatable.dart';

abstract class DriverHomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SelectStartingPoint extends DriverHomeEvent {
  final String pointType; // Starting Point
  final String location;

  SelectStartingPoint(this.pointType, this.location);

  @override
  List<Object> get props => [pointType, location];
}

class SelectDestinationPoint extends DriverHomeEvent {
  final String pointType; // Destination
  final String location;

  SelectDestinationPoint(this.pointType, this.location);

  @override
  List<Object> get props => [pointType, location];
}
