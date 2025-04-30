import 'package:equatable/equatable.dart';

abstract class RiderPendingRequestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPendingRequests extends RiderPendingRequestEvent {}

class DeletePendingRequest extends RiderPendingRequestEvent {
  final String requestId;

  DeletePendingRequest(this.requestId);

  @override
  List<Object> get props => [requestId];
}

class FilterPendingRequestsByDate extends RiderPendingRequestEvent {
  final DateTime? selectedDate;

  FilterPendingRequestsByDate(this.selectedDate);

  @override
  List<Object> get props => [selectedDate ?? ''];
}

class ClearPendingDateFilter extends RiderPendingRequestEvent {}
