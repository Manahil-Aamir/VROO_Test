import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/features/authentication/domain/usecases/get_token_usecase.dart';
import '../../../domain/usecases/cancel_ride.dart';
import '../../../domain/usecases/get_active_rides.dart';
import '../../../domain/usecases/static_ride.dart';
import '../event/active_rides_event.dart';
import '../state/active_rides_state.dart';

class ActiveRidesDriverBloc
    extends Bloc<ActiveRidesDriverEvent, ActiveRidesDriverState> {
  final GetActiveRidesDriver getActiveRidesDriver;
  final CancelRide cancelRide;
  final GetRideData getRideData;
  final GetTokenUseCase getTokenUseCase; // Add this line

  ActiveRidesDriverBloc({
    required this.getActiveRidesDriver,
    required this.cancelRide,
    required this.getRideData, // Initialize the new use case
    required this.getTokenUseCase, // Initialize the new use case
  }) : super(ActiveRidesDriverInitial()) {
    on<FetchActiveRidesDriver>(_onFetchActiveRidesDriver);
    on<FilterRidesByDate>(_onFilterRidesByDate);
    on<ClearDateFilter>(_onClearDateFilter);
    on<CancelRideEvent>(_onCancelRideEvent);
    on<GetRideDataEvent>(_onGetRideDataEvent); // Add the new event handler
    on<ClearErrorEvent>((event, emit) {
      if (state is ActiveRidesDriverLoaded) {
        emit((state as ActiveRidesDriverLoaded).copyWith(
          errorMessage: null,
          successMessage: null,
        ));
      }
    });
  }

  Future<void> _onFetchActiveRidesDriver(
    FetchActiveRidesDriver event,
    Emitter<ActiveRidesDriverState> emit,
  ) async {
    emit(ActiveRidesDriverLoading());
    try {
      final rides = await getActiveRidesDriver.execute();
      emit(ActiveRidesDriverLoaded(rides: rides, filteredRides: rides));
    } catch (e) {
      print('Error fetching active rides: $e');
      emit(ActiveRidesDriverError(e.toString()));
    }
  }

  void _onFilterRidesByDate(
    FilterRidesByDate event,
    Emitter<ActiveRidesDriverState> emit,
  ) {
    if (state is ActiveRidesDriverLoaded) {
      final currentState = state as ActiveRidesDriverLoaded;

      if (event.selectedDate == null) {
        // No date filter, show all rides
        emit(ActiveRidesDriverLoaded(
          rides: currentState.rides,
          filteredRides: currentState.rides,
          selectedDate: null,
        ));
      } else {
        // Filter rides by the selected date
        final filteredRides = currentState.rides.where((ride) {
          return ride.date.year == event.selectedDate!.year &&
              ride.date.month == event.selectedDate!.month &&
              ride.date.day == event.selectedDate!.day;
        }).toList();

        emit(ActiveRidesDriverLoaded(
          rides: currentState.rides,
          filteredRides: filteredRides,
          selectedDate: event.selectedDate,
        ));
      }
    }
  }

  void _onClearDateFilter(
    ClearDateFilter event,
    Emitter<ActiveRidesDriverState> emit,
  ) {
    if (state is ActiveRidesDriverLoaded) {
      final currentState = state as ActiveRidesDriverLoaded;
      emit(ActiveRidesDriverLoaded(
        rides: currentState.rides,
        filteredRides: currentState.rides,
        selectedDate: null,
      ));
    }
  }

  Future<void> _onCancelRideEvent(
    CancelRideEvent event,
    Emitter<ActiveRidesDriverState> emit,
  ) async {
    try {
      if (state is! ActiveRidesDriverLoaded) return;

      final currentState = state as ActiveRidesDriverLoaded;

      // Optimistically remove the ride
      final updatedRides =
          currentState.rides.where((r) => r.id != event.rideId).toList();
      final updatedFiltered = currentState.filteredRides
          .where((r) => r.id != event.rideId)
          .toList();

      // Show immediate UI update
      emit(currentState.copyWith(
        rides: updatedRides,
        filteredRides: updatedFiltered,
      ));

      // Perform actual cancellation
      await cancelRide.execute(event.rideId);

      // Show success message
      emit((state as ActiveRidesDriverLoaded)
          .copyWith(successMessage: 'Ride cancelled successfully'));
    } catch (e) {
      // Revert on error and show error message
      if (state is ActiveRidesDriverLoaded) {
        emit((state as ActiveRidesDriverLoaded)
            .copyWith(errorMessage: 'Failed to cancel ride: ${e.toString()}'));
      }
    }
  }

  Future<void> _onGetRideDataEvent(
    GetRideDataEvent event,
    Emitter<ActiveRidesDriverState> emit,
  ) async {
    try {
      final token = await getTokenUseCase.call();
      print('object token: $token');
      emit(ActiveRidesDriverLoading());
      try {
        final rideData = await getRideData.call(event.rideId, token!);
        print(rideData.passengers);
        emit(ActiveRideDataLoaded(rideData));
      } on Exception catch (e) {
        print('data issue$e');
        emit(ActiveRidesDriverError(e.toString()));
      }
      print('loaded ride data'); // Emit a new state for ride data
    } catch (e) {
      print('Error fetching ride data: $e');
      emit(ActiveRidesDriverError(e.toString()));
    }
  }
}
