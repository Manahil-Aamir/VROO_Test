import 'package:equatable/equatable.dart';

abstract class RideState extends Equatable {
  @override
  List<Object> get props => [];
}

class RideInitial extends RideState {}

class RideSubmitting extends RideState {}

class RideSubmitted extends RideState {}

class RideSubmissionFailed extends RideState {
  final String error;

  RideSubmissionFailed(this.error);

  @override
  List<Object> get props => [error];
}
