import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../rider_journey/domain/usecases/logout_usecase.dart';
import '../../../domain/usecases/ClearScheduleUseCase.dart';
import '../../../domain/usecases/get_driver_current_location.dart';
import '../event/driver_home_event.dart';
import '../state/driver_home_state.dart';

class DriverHomeBloc extends Bloc<DriverHomeEvent, DriverHomeState> {
  final GetDriverCurrentLocation getDriverCurrentLocation;
  final ClearPreferencesUseCase clearSharedPreferences;
  final Logout logout;

  DriverHomeBloc(
      this.getDriverCurrentLocation, this.clearSharedPreferences, this.logout)
      : super(DriverHomeInitial()) {
    on<LoadDriverCurrentLocation>(_onLoadDriverCurrentLocation);
    on<ClearSharedPreferencesEvent>(_onClearSharedPreferences);
    on<DriverLogoutEvent>(_onLogout);
  }

  Future<void> _onLoadDriverCurrentLocation(
    LoadDriverCurrentLocation event,
    Emitter<DriverHomeState> emit,
  ) async {
    emit(DriverHomeLoading());
    try {
      final LatLng location = await getDriverCurrentLocation.execute();
      emit(DriverHomeLoaded(location));
    } catch (e) {
      emit(DriverHomeError('Failed to load location'));
    }
  }

  Future<void> _onClearSharedPreferences(
    ClearSharedPreferencesEvent event,
    Emitter<DriverHomeState> emit,
  ) async {
    try {
      await clearSharedPreferences.execute();
      print('done');
      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      emit(DriverHomeError('Failed to clear shared preferences'));
    }
  }

  Future<void> _onLogout(
    DriverLogoutEvent event,
    Emitter<DriverHomeState> emit,
  ) async {
    try {
      await logout.logout();
      emit(DriverHomeLogoutSuccess());
    } catch (e) {
      emit(DriverHomeError('Failed to logout'));
    }
  }
}
