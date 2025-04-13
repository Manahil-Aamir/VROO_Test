import '../../../domain/entity/active_ride.dart';

abstract class ActiveRidesDriverState {}

class ActiveRidesDriverInitial extends ActiveRidesDriverState {}

class ActiveRidesDriverLoading extends ActiveRidesDriverState {}

class ActiveRidesDriverLoaded extends ActiveRidesDriverState {
  final List<ActiveRideEntity> rides;
  final List<ActiveRideEntity> filteredRides;
  final DateTime? selectedDate;
  final String? errorMessage;
  final String? successMessage;  // Add this field for success messages

  ActiveRidesDriverLoaded({
    required this.rides,
    this.filteredRides = const [],
    this.selectedDate,
    this.errorMessage,
    this.successMessage,  // Add this parameter
  });

  ActiveRidesDriverLoaded copyWith({
    List<ActiveRideEntity>? rides,
    List<ActiveRideEntity>? filteredRides,
    DateTime? selectedDate,
    String? errorMessage,
    String? successMessage,
  }) {
    return ActiveRidesDriverLoaded(
      rides: rides ?? this.rides,
      filteredRides: filteredRides ?? this.filteredRides,
      selectedDate: selectedDate ?? this.selectedDate,
      errorMessage: errorMessage,
      successMessage: successMessage,  
    );
  }
}

class ActiveRidesDriverError extends ActiveRidesDriverState {
  final String message;

  ActiveRidesDriverError(this.message);
}
