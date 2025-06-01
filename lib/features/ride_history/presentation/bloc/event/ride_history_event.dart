import 'package:equatable/equatable.dart';

abstract class RideHistoryEvent extends Equatable {
  const RideHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadDriverHistory extends RideHistoryEvent {}

class LoadRiderHistory extends RideHistoryEvent {}

class RefreshHistory extends RideHistoryEvent {
  final bool isDriverHistory;

  const RefreshHistory(this.isDriverHistory);

  @override
  List<Object> get props => [isDriverHistory];
}