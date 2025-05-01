import 'package:equatable/equatable.dart';
import 'package:vroo_test/features/ride_start/data/models/ridestart_data_model.dart';

abstract class RideStartState extends Equatable {
  const RideStartState();

  @override
  List<Object?> get props => [];
}

class RideStartInitial extends RideStartState {}

class RideStartLoading extends RideStartState {}

class RideStartSuccess extends RideStartState {
  final RidestartDataModel rideData;

  const RideStartSuccess(this.rideData);

  @override
  List<Object?> get props => [rideData];
}

class RideStartFailure extends RideStartState {
  final String errorMessage;

  const RideStartFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
