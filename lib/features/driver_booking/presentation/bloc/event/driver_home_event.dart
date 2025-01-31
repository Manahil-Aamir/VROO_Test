import 'package:equatable/equatable.dart';

abstract class DriverHomeEvent extends Equatable {
  const DriverHomeEvent();

  @override
  List<Object> get props => [];
}

class LoadDriverCurrentLocation extends DriverHomeEvent {}

// class ClearSharedPreferencesEvent extends DriverHomeEvent {}
