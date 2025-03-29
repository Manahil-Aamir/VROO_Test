import '../../../domain/entity/approved_rides.dart';

sealed class ApprovedRidesState {}

class ApprovedRidesInitial extends ApprovedRidesState {}
class ApprovedRidesLoading extends ApprovedRidesState {}
class ApprovedRidesLoaded extends ApprovedRidesState {
  final List<ApprovedRidesEntity> rides;
  ApprovedRidesLoaded(this.rides);
}
class ApprovedRidesError extends ApprovedRidesState {
  final String message;
  ApprovedRidesError(this.message);
}
