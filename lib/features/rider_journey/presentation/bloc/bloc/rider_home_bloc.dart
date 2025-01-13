import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../domain/usecases/rider_home_usecase.dart';
import '../event/rider_home_event.dart';
import '../state/rider_home_state.dart';

class RiderHomeBloc extends Bloc<RiderHomeEvent, RiderHomeState> {
  final GetCurrentLocation getCurrentLocation;

  RiderHomeBloc(this.getCurrentLocation) : super(RiderHomeInitial()) {
    on<LoadCurrentLocation>(_onLoadCurrentLocation);
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
}
