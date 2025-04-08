import '../../../domain/entity/active_ride.dart';

abstract class ActiveRidesState {}

class ActiveRidesInitial extends ActiveRidesState {}

class ActiveRidesLoading extends ActiveRidesState {}

class ActiveRidesLoaded extends ActiveRidesState {
  final List<ActiveRideEntity> rides;
  final List<ActiveRideEntity> filteredRides;
  final DateTime? selectedDate;

  ActiveRidesLoaded({
    required this.rides,
    this.filteredRides = const [],
    this.selectedDate,
  });
}

class ActiveRidesError extends ActiveRidesState {
  final String message;

  ActiveRidesError(this.message);
}
