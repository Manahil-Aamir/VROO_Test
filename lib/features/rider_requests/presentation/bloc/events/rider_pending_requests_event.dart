import 'package:equatable/equatable.dart';

abstract class RiderPendingRequestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPendingRequests extends RiderPendingRequestEvent {}
