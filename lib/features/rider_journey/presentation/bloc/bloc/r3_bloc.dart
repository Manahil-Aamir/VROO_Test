import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vroo_test/features/rider_journey/presentation/bloc/event/r3_event.dart';
import 'package:vroo_test/features/rider_journey/presentation/bloc/state/r3_state.dart';

import '../../../domain/usecases/get_coordinates_usecase.dart';
import '../../../domain/usecases/request_ride_usecase.dart';

class R3Bloc extends Bloc<R3Event, R3State> {
  final RequestRideUseCase requestRideUseCase;
  final GetCoordinatesUseCase getCoordinatesUseCase;

  R3Bloc(this.requestRideUseCase, this.getCoordinatesUseCase)
      : super(RideRequestInitial()) {
    on<SendRideRequestEvent>(_onSendRideRequest);
    on<GetCoordinatesEvent>(_onGetCoordinates);
  }

  Future<void> _onSendRideRequest(
      SendRideRequestEvent event, Emitter<R3State> emit) async {
    emit(RideRequestLoading());
    print("ride request");
    try {
      final response = await requestRideUseCase(event.rideData);
      print(response);
      emit(RideRequestSuccess(response as Map<String, dynamic>));
    } catch (e) {
      emit(RideRequestFailure(e.toString()));
    }
  }

  Future<void> _onGetCoordinates(
      GetCoordinatesEvent event, Emitter<R3State> emit) async {
    emit(RideRequestLoading());
    try {
      final coordinates = await getCoordinatesUseCase(event.placeId);
      print('Coordinates: $coordinates');
      emit(CoordinatesLoaded(coordinates, isSource: event.isSource));
    } catch (e) {
      emit(RideRequestFailure(e.toString()));
    }
  }
}
