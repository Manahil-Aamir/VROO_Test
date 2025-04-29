import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/cancel_join_request_usecase.dart';
import '../../../domain/usecases/get_ride_request_joins.dart';
import '../events/ride_request_join_event.dart';
import '../states/ride_request_join_state.dart';

class RideRequestJoinBloc extends Bloc<RideRequestJoinEvent, RideRequestJoinState> {
  final GetPendingRideRequestJoinsUsecase getPendingRideRequestJoinsUsecase;
  final CancelJoinRequestUsecase cancelJoinRequestUsecase;

  RideRequestJoinBloc(this.getPendingRideRequestJoinsUsecase, this.cancelJoinRequestUsecase) : super(RideRequestJoinInitial()) {
    on<FetchPendingRideRequestJoins>(_onFetchPendingRideRequestJoins);
    on<CancelJoinRequest>(_onCancelJoinRequest);
  }

  Future<void> _onFetchPendingRideRequestJoins(
      FetchPendingRideRequestJoins event, Emitter<RideRequestJoinState> emit) async {
    try {
      emit(RideRequestJoinLoading());

      final joins = await getPendingRideRequestJoinsUsecase(event.rideRequestId);

      emit(RideRequestJoinLoaded(joins));
    } catch (e) {
      emit(RideRequestJoinError(e.toString()));
    }
  }

  Future<void> _onCancelJoinRequest(
      CancelJoinRequest event, Emitter<RideRequestJoinState> emit) async {
    try {
      // If we're currently showing loaded data
      if (state is RideRequestJoinLoaded) {
        print('here in cancelJoinRequest bloc');
        final currentState = state as RideRequestJoinLoaded;
        
        // Remove the cancelled request from the list
        final updatedJoins = currentState.joins
            .where((join) => join.id != event.joinRequestId)
            .toList();

        // Show the updated list immediately
        emit(RideRequestJoinLoaded(updatedJoins));
      }

      // Make the API call in the background
      print('calling cancelJoinRequestUsecase with id: ${event.joinRequestId}');
      await cancelJoinRequestUsecase(event.joinRequestId);
      
      // Optional: You could add a small delay and refresh to ensure sync with server
      // await Future.delayed(Duration(seconds: 1));
      // add(FetchPendingRideRequestJoins(event.rideRequestId));
      
    } catch (e) {
      // If error occurs, revert to previous state
      if (state is RideRequestJoinLoaded) {
        emit(state); // Re-emit the previous state
      }
      emit(RideRequestJoinError(e.toString()));
    }
  }
}
