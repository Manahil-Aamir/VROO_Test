import 'package:equatable/equatable.dart';

import '../../../domain/entity/driver_history_entity.dart';
import '../../../domain/entity/rider_history_entity.dart';

abstract class RideHistoryState extends Equatable {
  const RideHistoryState();

  @override
  List<Object> get props => [];
}

class RideHistoryInitial extends RideHistoryState {}

class RideHistoryLoading extends RideHistoryState {}

class DriverHistoryLoaded extends RideHistoryState {
  final DriverHistoryEntity history;

  const DriverHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class RiderHistoryLoaded extends RideHistoryState {
  final RiderHistoryEntity history;

  const RiderHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class RideHistoryError extends RideHistoryState {
  final String message;

  const RideHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
