import 'package:equatable/equatable.dart';

abstract class RiderApprovedRequestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchApprovedRequests extends RiderApprovedRequestEvent {}

class FilterApprovedRequestsByDate extends RiderApprovedRequestEvent {
  final DateTime? selectedDate;

  FilterApprovedRequestsByDate(this.selectedDate);

  @override
  List<Object> get props => [selectedDate ?? ''];
}

class ClearApprovedDateFilter extends RiderApprovedRequestEvent {}
