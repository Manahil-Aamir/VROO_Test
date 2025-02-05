import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/approve_ride_request.dart';
import '../../../domain/usecases/get_rides_details.dart';
import '../event/rides_details_event.dart';
import '../state/rides_details_state.dart';


class RideDetailsBloc extends Bloc<RideDetailsEvent, RideDetailsState> {  
  final GetRideDetails getRideDetails;
  final ApproveRideRequest approveRideRequest; 

  RideDetailsBloc({
    required this.getRideDetails,
    required this.approveRideRequest, // Add this
  }) : super(RideDetailsInitial()) {
    on<FetchRideDetails>(_onFetchRideDetails);
    on<ApproveRideRequestEvent>(_onApproveRideRequest); // New handler
  }

  Future<void> _onFetchRideDetails(
    FetchRideDetails event,
    Emitter<RideDetailsState> emit,
  ) async {
    emit(RideDetailsLoading());
    try {
      final rides = await getRideDetails.execute(event.driverId);
      emit(RideDetailsLoaded(rides));
    } catch (e) {
      emit(RideDetailsError(e.toString()));
    }
  }

  Future<void> _onApproveRideRequest(
    ApproveRideRequestEvent event,
    Emitter<RideDetailsState> emit,
  ) async {
    try {
      await approveRideRequest.execute(event.rideRequestId, event.rideId);
      // Refresh data after approval
      final rides = await getRideDetails.execute(event.rideId);
      emit(RideDetailsLoaded(rides));
    } catch (e) {
      emit(RideDetailsError(e.toString()));
    }
  }

}
