import '../../../domain/entity/active_ride.dart';

abstract class ActiveRidesState {}

class ActiveRidesInitial extends ActiveRidesState {}

class ActiveRidesLoading extends ActiveRidesState {}

class ActiveRidesLoaded extends ActiveRidesState {
  final List<ActiveRideEntity> rides;
  final List<ActiveRideEntity> filteredRides;
  final DateTime? selectedDate;
  final String? errorMessage;
  final String? successMessage;  // Add this field for success messages

  ActiveRidesLoaded({
    required this.rides,
    this.filteredRides = const [],
    this.selectedDate,
    this.errorMessage,
    this.successMessage,  // Add this parameter
  });

  ActiveRidesLoaded copyWith({
    List<ActiveRideEntity>? rides,
    List<ActiveRideEntity>? filteredRides,
    DateTime? selectedDate,
    String? errorMessage,
    String? successMessage,
  }) {
    return ActiveRidesLoaded(
      rides: rides ?? this.rides,
      filteredRides: filteredRides ?? this.filteredRides,
      selectedDate: selectedDate ?? this.selectedDate,
      errorMessage: errorMessage,
      successMessage: successMessage,  
    );
  }
}

class ActiveRidesError extends ActiveRidesState {
  final String message;

  ActiveRidesError(this.message);
}
