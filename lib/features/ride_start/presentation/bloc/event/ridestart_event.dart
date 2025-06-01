import 'package:equatable/equatable.dart';
import '../../../data/models/give_review_model.dart';

abstract class RideStartEvent extends Equatable {
  const RideStartEvent();

  @override
  List<Object?> get props => [];
}

class InitializeRideEvent extends RideStartEvent {
  final String rideId;

  const InitializeRideEvent(this.rideId);

  @override
  List<Object?> get props => [rideId];
}

class SubmitReviewEvent extends RideStartEvent {
  final GiveReviewModel reviewModel;

  const SubmitReviewEvent(this.reviewModel);

  @override
  List<Object?> get props => [reviewModel];
}

// New events
class UpdatePassengerEvent extends RideStartEvent {
  final String passengerId;
  final String action;

  const UpdatePassengerEvent(this.passengerId, this.action);

  @override
  List<Object?> get props => [passengerId, action];
}

class EndRideEvent extends RideStartEvent {
  const EndRideEvent();
}
