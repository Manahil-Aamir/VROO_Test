import 'package:bloc/bloc.dart';
import '../../../domain/usecases/get_driver_ride_history.dart';
import '../../../domain/usecases/get_rider_ride_history.dart';
import '../event/ride_history_event.dart';
import '../state/ride_history_state.dart';

class RideHistoryBloc extends Bloc<RideHistoryEvent, RideHistoryState> {
  final GetDriverRideHistory getDriverHistory;
  final GetRiderRideHistory getRiderHistory;

  RideHistoryBloc({
    required this.getDriverHistory,
    required this.getRiderHistory,
  }) : super(RideHistoryInitial()) {
    on<LoadDriverHistory>(_onLoadDriverHistory);
    on<LoadRiderHistory>(_onLoadRiderHistory);
    on<RefreshHistory>(_onRefreshHistory);
  }

  Future<void> _onLoadDriverHistory(
    LoadDriverHistory event,
    Emitter<RideHistoryState> emit,
  ) async {
    emit(RideHistoryLoading());
    try {
      final history = await getDriverHistory();
      emit(DriverHistoryLoaded(history));
    } catch (e) {
      emit(RideHistoryError(e.toString()));
    }
  }

  Future<void> _onLoadRiderHistory(
    LoadRiderHistory event,
    Emitter<RideHistoryState> emit,
  ) async {
    emit(RideHistoryLoading());
    try {
      final history = await getRiderHistory();
      emit(RiderHistoryLoaded(history));
    } catch (e) {
      emit(RideHistoryError(e.toString()));
    }
  }

  Future<void> _onRefreshHistory(
    RefreshHistory event,
    Emitter<RideHistoryState> emit,
  ) async {
    emit(RideHistoryLoading());
    try {
      if (event.isDriverHistory) {
        final history = await getDriverHistory();
        emit(DriverHistoryLoaded(history));
      } else {
        final history = await getRiderHistory();
        emit(RiderHistoryLoaded(history));
      }
    } catch (e) {
      emit(RideHistoryError(e.toString()));
    }
  }
}
