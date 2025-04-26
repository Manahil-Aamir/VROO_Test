import 'package:equatable/equatable.dart';
import '../../../domain/entity/ride_request_join.dart';

abstract class RideRequestJoinState extends Equatable {
  const RideRequestJoinState();

  @override
  List<Object> get props => [];
}

class RideRequestJoinInitial extends RideRequestJoinState {}

class RideRequestJoinLoading extends RideRequestJoinState {}

class RideRequestJoinLoaded extends RideRequestJoinState {
  final List<RideRequestJoinEntity> joins;

  const RideRequestJoinLoaded(this.joins);

  @override
  List<Object> get props => [joins];
}

class RideRequestJoinError extends RideRequestJoinState {
  final String message;

  const RideRequestJoinError(this.message);

  @override
  List<Object> get props => [message];
}
