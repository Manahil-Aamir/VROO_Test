import '../../../domain/entity/rides_details.dart';

sealed class RideDetailsState {}

class RideDetailsInitial extends RideDetailsState {}
class RideDetailsLoading extends RideDetailsState {}
class RideDetailsLoaded extends RideDetailsState {
  final List<RideDetailsEntity> rides;
  RideDetailsLoaded(this.rides);
}
class RideDetailsError extends RideDetailsState {
  final String message;
  RideDetailsError(this.message);
}
