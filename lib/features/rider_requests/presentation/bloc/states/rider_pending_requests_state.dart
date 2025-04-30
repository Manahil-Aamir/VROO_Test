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
  final List<RiderPendingRequest> filteredRequests;
  final DateTime? selectedDate;

  RiderPendingRequestLoaded({
    required this.requests,
    this.filteredRequests = const [],
    this.selectedDate,
  });

  @override
  List<Object> get props => [requests, filteredRequests, selectedDate ?? ''];

  RiderPendingRequestLoaded copyWith({
    List<RiderPendingRequest>? requests,
    List<RiderPendingRequest>? filteredRequests,
    DateTime? selectedDate,
  }) {
    return RiderPendingRequestLoaded(
      requests: requests ?? this.requests,
      filteredRequests: filteredRequests ?? this.filteredRequests,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class RiderPendingRequestError extends RiderPendingRequestState {
  final String message;

  RiderPendingRequestError(this.message);

  @override
  List<Object> get props => [message];
}

class RiderPendingRequestDeleted extends RiderPendingRequestState {
  final String requestId;
  final List<RiderPendingRequest> remainingRequests;
  final List<RiderPendingRequest> remainingFilteredRequests;
  final DateTime? selectedDate;

  RiderPendingRequestDeleted({
    required this.requestId,
    required this.remainingRequests,
    required this.remainingFilteredRequests,
    this.selectedDate,
  });

  @override
  List<Object> get props => [
        requestId,
        remainingRequests,
        remainingFilteredRequests,
        selectedDate ?? '',
      ];
}
