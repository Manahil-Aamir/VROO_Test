import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_active_rides.dart';
import '../event/active_rides_event.dart';
import '../state/active_rides_state.dart';

class ActiveRidesBloc extends Bloc<ActiveRidesEvent, ActiveRidesState> {
  final GetActiveRides getActiveRides;

  ActiveRidesBloc(this.getActiveRides) : super(ActiveRidesInitial()) {
    on<FetchActiveRides>(_onFetchActiveRides);
    on<FilterRidesByDate>(_onFilterRidesByDate);
    on<ClearDateFilter>(_onClearDateFilter);
  }

  Future<void> _onFetchActiveRides(
    FetchActiveRides event,
    Emitter<ActiveRidesState> emit,
  ) async {
    emit(ActiveRidesLoading());
    try {
      final rides = await getActiveRides.execute(event.driverId);
      emit(ActiveRidesLoaded(rides: rides, filteredRides: rides));
    } catch (e) {
      emit(ActiveRidesError(e.toString()));
    }
  }

  void _onFilterRidesByDate(
    FilterRidesByDate event,
    Emitter<ActiveRidesState> emit,
  ) {
    if (state is ActiveRidesLoaded) {
      final currentState = state as ActiveRidesLoaded;
      
      if (event.selectedDate == null) {
        // No date filter, show all rides
        emit(ActiveRidesLoaded(
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
        
        emit(ActiveRidesLoaded(
          rides: currentState.rides,
          filteredRides: filteredRides,
          selectedDate: event.selectedDate,
        ));
      }
    }
  }

  void _onClearDateFilter(
    ClearDateFilter event,
    Emitter<ActiveRidesState> emit,
  ) {
    if (state is ActiveRidesLoaded) {
      final currentState = state as ActiveRidesLoaded;
      emit(ActiveRidesLoaded(
        rides: currentState.rides,
        filteredRides: currentState.rides,
        selectedDate: null,
      ));
    }
  }
}
