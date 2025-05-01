import 'package:equatable/equatable.dart';
import 'package:vroo_test/features/ride_start/data/models/rider_view_model.dart';

abstract class RideViewState extends Equatable {
  const RideViewState();

  @override
  List<Object?> get props => [];
}

class RideViewInitial extends RideViewState {}

class RideViewLoading extends RideViewState {}

class RideViewSuccess extends RideViewState {
  final RideViewModel rideData;

  const RideViewSuccess(this.rideData);

  @override
  List<Object?> get props => [rideData];
}

class RideViewFailure extends RideViewState {
  final String errorMessage;

  const RideViewFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
