import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/data_source/d1_data_source.dart';
import '../../../domain/usecases/get_driver_current_location.dart';
import '../event/driver_home_event.dart';
import '../state/driver_home_state.dart';

class DriverHomeBloc extends Bloc<DriverHomeEvent, DriverHomeState> {
  final GetDriverCurrentLocation getDriverCurrentLocation;
  final D1DataSource d1DataSource;

  DriverHomeBloc(this.getDriverCurrentLocation, this.d1DataSource)
      : super(DriverHomeInitial()) {
    on<LoadDriverCurrentLocation>(_onLoadDriverCurrentLocation);
    // on<ClearSharedPreferencesEvent>(_onClearSharedPreferences);
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

  // Future<void> _onClearSharedPreferences(
  //   ClearSharedPreferencesEvent event,
  //   Emitter<DriverHomeState> emit,
  // ) async {
  //   await d1DataSource.clearScheduleData(); // Clear SharedPreferences
  // }
}