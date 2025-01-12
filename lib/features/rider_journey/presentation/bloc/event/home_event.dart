import 'package:equatable/equatable.dart';

abstract class RiderHomeEvent extends Equatable {
  const RiderHomeEvent();

  @override
  List<Object> get props => [];
}

class LoadCurrentLocation extends RiderHomeEvent {}
