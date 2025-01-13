import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../domain/usecases/get_driver_current_location.dart';
import '../event/driver_home_event.dart';
import '../state/driver_home_state.dart';

class DriverHomeBloc extends Bloc<DriverHomeEvent, DriverHomeState> {
  final GetDriverCurrentLocation getDriverCurrentLocation;

  DriverHomeBloc(this.getDriverCurrentLocation) : super(DriverHomeInitial()) {
    on<LoadDriverCurrentLocation>(_onLoadDriverCurrentLocation);
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
}
