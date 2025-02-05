import 'package:vroo_test/features/driver_requests/domain/entity/active_ride.dart';

sealed class ActiveRidesState {}

class ActiveRidesInitial extends ActiveRidesState {}
class ActiveRidesLoading extends ActiveRidesState {}
class ActiveRidesLoaded extends ActiveRidesState {
  final List<ActiveRideEntity> rides;
  ActiveRidesLoaded(this.rides);
}
class ActiveRidesError extends ActiveRidesState {
  final String message;
  ActiveRidesError(this.message);
}
