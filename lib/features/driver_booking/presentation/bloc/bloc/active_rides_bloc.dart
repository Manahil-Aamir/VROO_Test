import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_active_rides.dart';
import '../event/active_rides_event.dart';
import '../state/active_rides_state.dart';

class ActiveRidesBloc extends Bloc<ActiveRidesEvent, ActiveRidesState> {
  final GetActiveRides getActiveRides;

  ActiveRidesBloc(this.getActiveRides) : super(ActiveRidesInitial()) {
    on<FetchActiveRides>(_onFetchActiveRides);
  }

  Future<void> _onFetchActiveRides(
    FetchActiveRides event,
    Emitter<ActiveRidesState> emit,
  ) async {
    emit(ActiveRidesLoading());
    try {
      final rides = await getActiveRides.execute(event.driverId);
      emit(ActiveRidesLoaded(rides));
    } catch (e) {
      emit(ActiveRidesError(e.toString()));
    }
  }
}
