import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/approve_ride_request.dart';
import '../../../domain/usecases/get_pending_rides.dart';
import '../event/pending_rides_event.dart';
import '../state/pending_rides_state.dart';


class PendingRidesBloc extends Bloc<PendingRidesEvent, PendingRidesState> {  
  final GetPendingRides getPendingRides;
  final ApproveRideRequest approveRideRequest; 

  PendingRidesBloc({
    required this.getPendingRides,
    required this.approveRideRequest, // Add this
  }) : super(PendingRidesInitial()) {
    on<FetchPendingRides>(_onFetchPendingRides);
    on<ApproveRideRequestEvent>(_onApproveRideRequest); // New handler
  }

  Future<void> _onFetchPendingRides(
    FetchPendingRides event,
    Emitter<PendingRidesState> emit,
  ) async {
    emit(PendingRidesLoading());
    try {
      final rides = await getPendingRides.execute(event.driverId);
      emit(PendingRidesLoaded(rides));
    } catch (e) {
      emit(PendingRidesError(e.toString()));
    }
  }

  Future<void> _onApproveRideRequest(
    ApproveRideRequestEvent event,
    Emitter<PendingRidesState> emit,
  ) async {
    try {
      await approveRideRequest.execute(event.rideRequestId, event.rideId);
      // Emit a success state (optional, if needed)
      emit(RideApprovalSuccess());
      // Refresh data after approval
      final rides = await getPendingRides.execute(event.rideId);
      emit(PendingRidesLoaded(rides));
    } catch (e) {
      emit(PendingRidesError(e.toString()));
    }
  }

}
