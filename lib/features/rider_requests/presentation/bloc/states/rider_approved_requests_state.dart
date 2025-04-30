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
  final List<RiderApprovedRequest> filteredRequests;
  final DateTime? selectedDate;

  RiderApprovedRequestLoaded({
    required this.requests,
    this.filteredRequests = const [],
    this.selectedDate,
  });

  @override
  List<Object> get props => [requests, filteredRequests, selectedDate ?? ''];

  RiderApprovedRequestLoaded copyWith({
    List<RiderApprovedRequest>? requests,
    List<RiderApprovedRequest>? filteredRequests,
    DateTime? selectedDate,
  }) {
    return RiderApprovedRequestLoaded(
      requests: requests ?? this.requests,
      filteredRequests: filteredRequests ?? this.filteredRequests,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class RiderApprovedRequestError extends RiderApprovedRequestState {
  final String message;

  RiderApprovedRequestError(this.message);

  @override
  List<Object> get props => [message];
}
