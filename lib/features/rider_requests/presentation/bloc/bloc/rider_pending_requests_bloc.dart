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
    on<FilterPendingRequestsByDate>(_onFilterPendingRequestsByDate);
    on<ClearPendingDateFilter>(_onClearPendingDateFilter);
  }

  Future<void> _onFetchPendingRequests(
    FetchPendingRequests event,
    Emitter<RiderPendingRequestState> emit,
  ) async {
    emit(RiderPendingRequestLoading());
    try {
      final requests = await getPendingRequestsUseCase.execute();
      emit(RiderPendingRequestLoaded(
        requests: requests,
        filteredRequests: requests,
        selectedDate: null, // Explicitly set to null initially
      ));
    } catch (e) {
      emit(RiderPendingRequestError(e.toString()));
    }
  }

  void _onFilterPendingRequestsByDate(
    FilterPendingRequestsByDate event,
    Emitter<RiderPendingRequestState> emit,
  ) {
    if (state is RiderPendingRequestLoaded) {
      final currentState = state as RiderPendingRequestLoaded;
      
      if (event.selectedDate == null) {
        emit(RiderPendingRequestLoaded(
          requests: currentState.requests,
          filteredRequests: currentState.requests,
          selectedDate: null,
        ));
      } else {
        final filteredRequests = currentState.requests.where((request) {
          return request.date.year == event.selectedDate!.year &&
                 request.date.month == event.selectedDate!.month &&
                 request.date.day == event.selectedDate!.day;
        }).toList();
        
        emit(RiderPendingRequestLoaded(
          requests: currentState.requests,
          filteredRequests: filteredRequests,
          selectedDate: event.selectedDate,
        ));
      }
    }
  }

  void _onClearPendingDateFilter(
    ClearPendingDateFilter event,
    Emitter<RiderPendingRequestState> emit,
  ) {
    if (state is RiderPendingRequestLoaded) {
      final currentState = state as RiderPendingRequestLoaded;
      
      // Create a completely new state object to ensure UI updates properly
      emit(RiderPendingRequestLoaded(
        requests: currentState.requests,
        filteredRequests: currentState.requests, 
        selectedDate: null, 
      ));
    } else if (state is RiderPendingRequestDeleted) {
      final currentState = state as RiderPendingRequestDeleted;
      
      emit(RiderPendingRequestLoaded(
        requests: currentState.remainingRequests,
        filteredRequests: currentState.remainingRequests, 
        selectedDate: null, 
      ));
    }
  }

  Future<void> _onDeletePendingRequest(
    DeletePendingRequest event,
    Emitter<RiderPendingRequestState> emit,
  ) async {
    if (state is RiderPendingRequestLoaded) {
      final currentState = state as RiderPendingRequestLoaded;
      
      try {
        await deleteRideRequestUseCase.execute(event.requestId);
        
        final updatedRequests = currentState.requests
            .where((request) => request.id != event.requestId)
            .toList();
            
        final updatedFiltered = currentState.filteredRequests
            .where((request) => request.id != event.requestId)
            .toList();
        
        emit(RiderPendingRequestDeleted(
          requestId: event.requestId,
          remainingRequests: updatedRequests,
          remainingFilteredRequests: updatedFiltered,
          selectedDate: currentState.selectedDate,
        ));
      } catch (e) {
        emit(RiderPendingRequestError(e.toString()));
      }
    }
  }
}
