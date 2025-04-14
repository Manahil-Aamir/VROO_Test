import 'package:equatable/equatable.dart';

abstract class RiderApprovedRequestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchApprovedRequests extends RiderApprovedRequestEvent {}
