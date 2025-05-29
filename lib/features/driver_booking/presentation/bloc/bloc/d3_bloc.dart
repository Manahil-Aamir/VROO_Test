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
    print('🚀 RideBloc: Starting ride submission...');
    emit(RideSubmitting());
    
    try {
      print('🚀 RideBloc: About to call submitRideRequest use case');
      print('🚀 RideBloc: RideRequest data: ${event.rideRequest.toString()}');
      
      await submitRideRequest(event.rideRequest);
      
      print('✅ RideBloc: Successfully submitted ride request');
      emit(RideSubmitted());
    } catch (e, stackTrace) {
      print('❌ RideBloc: Error occurred: $e');
      print('❌ RideBloc: Stack trace: $stackTrace');
      emit(RideSubmissionFailed(e.toString()));
    }
  }
}
