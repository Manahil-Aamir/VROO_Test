import 'package:equatable/equatable.dart';
import '../../../domain/entity/ride_request.dart';

abstract class RideEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitRide extends RideEvent {
  final RideRequest rideRequest;

  SubmitRide(this.rideRequest);

  @override
  List<Object> get props => [rideRequest];
}


