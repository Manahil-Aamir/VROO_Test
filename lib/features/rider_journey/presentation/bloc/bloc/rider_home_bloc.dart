import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../domain/usecases/clear_preferences_usecase.dart';
import '../../../domain/usecases/rider_home_usecase.dart';
import '../event/rider_home_event.dart';
import '../state/rider_home_state.dart';

class RiderHomeBloc extends Bloc<RiderHomeEvent, RiderHomeState> {
  final GetCurrentLocation getCurrentLocation;
  final ClearPreferencesUseCase clearSharedPreferences;

  RiderHomeBloc(this.getCurrentLocation, this.clearSharedPreferences)
      : super(RiderHomeInitial()) {
    on<LoadCurrentLocation>(_onLoadCurrentLocation);
    on<ClearSharedPreferencesEvent>(_onClearSharedPreferences);
  }

  Future<void> _onLoadCurrentLocation(
    LoadCurrentLocation event,
    Emitter<RiderHomeState> emit,
  ) async {
    emit(RiderHomeLoading());
    try {
      final LatLng location = await getCurrentLocation.execute();
      emit(RiderHomeLoaded(location));
    } catch (e) {
      emit(RiderHomeError('Failed to load location'));
    }
  }

  Future<void> _onClearSharedPreferences(
    ClearSharedPreferencesEvent event,
    Emitter<RiderHomeState> emit,
  ) async {
    try {
      await clearSharedPreferences.execute();
    } catch (e) {
      emit(RiderHomeError('Failed to clear shared preferences'));
    }
  }
}
