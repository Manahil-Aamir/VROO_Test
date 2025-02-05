import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/submit_ride_request.dart';
import '../event/d3_event.dart';
import '../state/d3_state.dart';

class RideBloc extends Bloc<RideEvent, RideState> {
  final SubmitRideRequest submitRideRequest;

  RideBloc(this.submitRideRequest) : super(RideInitial()) {
    on<SubmitRide>(_onSubmitRide);
  }

  Future<void> _onSubmitRide(SubmitRide event, Emitter<RideState> emit) async {
    emit(RideSubmitting());
    try {
      await submitRideRequest(event.rideRequest);
      emit(RideSubmitted());
    } catch (e) {
      emit(RideSubmissionFailed(e.toString()));
    }
  }
}
