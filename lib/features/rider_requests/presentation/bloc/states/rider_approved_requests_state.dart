import 'package:equatable/equatable.dart';

import '../../../domain/entity/rider_approved_request_entity.dart';

abstract class RiderApprovedRequestState extends Equatable {
  @override
  List<Object> get props => [];
}

class RiderApprovedRequestInitial extends RiderApprovedRequestState {}

class RiderApprovedRequestLoading extends RiderApprovedRequestState {}

class RiderApprovedRequestLoaded extends RiderApprovedRequestState {
  final List<RiderApprovedRequest> requests;

  RiderApprovedRequestLoaded(this.requests);

  @override
  List<Object> get props => [requests];
}

class RiderApprovedRequestError extends RiderApprovedRequestState {
  final String message;

  RiderApprovedRequestError(this.message);

  @override
  List<Object> get props => [message];
}
