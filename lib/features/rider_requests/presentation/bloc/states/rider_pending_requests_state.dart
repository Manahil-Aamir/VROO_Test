import 'package:equatable/equatable.dart';

import '../../../domain/entity/rider_pending_request_entity.dart';

abstract class RiderPendingRequestState extends Equatable {
  @override
  List<Object> get props => [];
}

class RiderPendingRequestInitial extends RiderPendingRequestState {}

class RiderPendingRequestLoading extends RiderPendingRequestState {}

class RiderPendingRequestLoaded extends RiderPendingRequestState {
  final List<RiderPendingRequest> requests;

  RiderPendingRequestLoaded(this.requests);

  @override
  List<Object> get props => [requests];
}

class RiderPendingRequestError extends RiderPendingRequestState {
  final String message;

  RiderPendingRequestError(this.message);

  @override
  List<Object> get props => [message];
}
