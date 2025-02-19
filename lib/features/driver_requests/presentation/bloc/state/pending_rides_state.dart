import '../../../domain/entity/pending_rides.dart';

sealed class PendingRidesState {}

class PendingRidesInitial extends PendingRidesState {}
class PendingRidesLoading extends PendingRidesState {}
class PendingRidesLoaded extends PendingRidesState {
  final List<PendingRidesEntity> rides;
  PendingRidesLoaded(this.rides);
}
class PendingRidesError extends PendingRidesState {
  final String message;
  PendingRidesError(this.message);
}
