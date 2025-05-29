import 'package:equatable/equatable.dart';
import 'package:vroo_test/features/ride_start/data/models/ridestart_data_model.dart';

import '../../../data/models/review_model.dart';

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

class ReviewLoading extends RideStartState {}

class ReviewSuccess extends RideStartState {
  final ReviewModel reviewData;

  const ReviewSuccess(this.reviewData);

  @override
  List<Object?> get props => [reviewData];
}

class ReviewFailure extends RideStartState {
  final String errorMessage;

  const ReviewFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

// New states for UpdatePassenger
class UpdatePassengerLoading extends RideStartState {}

class UpdatePassengerSuccess extends RideStartState {
  final Map<String, dynamic> passengerData;

  const UpdatePassengerSuccess(this.passengerData);

  @override
  List<Object?> get props => [passengerData];
}

class UpdatePassengerFailure extends RideStartState {
  final String errorMessage;

  const UpdatePassengerFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

// New states for EndRide
class EndRideLoading extends RideStartState {}

class EndRideSuccess extends RideStartState {
  final Map<String, dynamic> endRideData;

  const EndRideSuccess(this.endRideData);

  @override
  List<Object?> get props => [endRideData];
}

class EndRideFailure extends RideStartState {
  final String errorMessage;

  const EndRideFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
