import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/delete_ride_request_usecase.dart';
import '../../../domain/usecases/get_pending_ride_requests.dart';
import '../events/rider_pending_requests_event.dart';
import '../states/rider_pending_requests_state.dart';

class RiderPendingRequestBloc extends Bloc<RiderPendingRequestEvent, RiderPendingRequestState> {
  final GetPendingRequestsUseCase getPendingRequestsUseCase;
  final DeleteRideRequestUseCase deleteRideRequestUseCase;

  RiderPendingRequestBloc({
    required this.getPendingRequestsUseCase,
    required this.deleteRideRequestUseCase,
  }) : super(RiderPendingRequestInitial()) {
    on<FetchPendingRequests>(_onFetchPendingRequests);
    on<DeletePendingRequest>(_onDeletePendingRequest);
  }

  Future<void> _onFetchPendingRequests(
    FetchPendingRequests event,
    Emitter<RiderPendingRequestState> emit,
  ) async {
    emit(RiderPendingRequestLoading());
    try {
      final requests = await getPendingRequestsUseCase.execute();
      emit(RiderPendingRequestLoaded(requests));
    } catch (e) {
      emit(RiderPendingRequestError(e.toString()));
    }
  }

  Future<void> _onDeletePendingRequest(
    DeletePendingRequest event,
    Emitter<RiderPendingRequestState> emit,
  ) async {
    // If current state is loaded, show loading while keeping current data
    if (state is RiderPendingRequestLoaded) {
      final currentState = state as RiderPendingRequestLoaded;
      emit(RiderPendingRequestLoaded(currentState.requests)); // Re-emit to show loading
    } else {
      emit(RiderPendingRequestLoading());
    }

    try {
      await deleteRideRequestUseCase.execute(event.requestId);
      
      if (state is RiderPendingRequestLoaded) {
        final currentState = state as RiderPendingRequestLoaded;
        final updatedRequests = currentState.requests
            .where((request) => request.id != event.requestId)
            .toList();
        emit(RiderPendingRequestDeleted(event.requestId, updatedRequests));
      }
    } catch (e) {
      emit(RiderPendingRequestError(e.toString()));
      // Optionally re-emit the loaded state with original data if you want to recover
      if (state is RiderPendingRequestLoaded) {
        emit(state);
      }
    }
  }
}

