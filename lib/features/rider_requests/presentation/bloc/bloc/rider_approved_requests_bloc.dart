import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_approved_ride_requests.dart';
import '../events/rider_approved_requests_event.dart';
import '../states/rider_approved_requests_state.dart';

class RiderApprovedRequestBloc extends Bloc<RiderApprovedRequestEvent, RiderApprovedRequestState> {
  final GetApprovedRequestsUseCase getApprovedRequestsUseCase;

  RiderApprovedRequestBloc({required this.getApprovedRequestsUseCase})
      : super(RiderApprovedRequestInitial()) {
    on<FetchApprovedRequests>(_onFetchApprovedRequests);
    on<FilterApprovedRequestsByDate>(_onFilterApprovedRequestsByDate);
    on<ClearApprovedDateFilter>(_onClearApprovedDateFilter);
  }

  Future<void> _onFetchApprovedRequests(
    FetchApprovedRequests event,
    Emitter<RiderApprovedRequestState> emit,
  ) async {
    emit(RiderApprovedRequestLoading());
    try {
      final requests = await getApprovedRequestsUseCase.execute();
      emit(RiderApprovedRequestLoaded(
        requests: requests,
        filteredRequests: requests,
        selectedDate: null, // Explicitly set to null initially
      ));
    } catch (e) {
      emit(RiderApprovedRequestError(e.toString()));
    }
  }

  void _onFilterApprovedRequestsByDate(
    FilterApprovedRequestsByDate event,
    Emitter<RiderApprovedRequestState> emit,
  ) {
    if (state is RiderApprovedRequestLoaded) {
      final currentState = state as RiderApprovedRequestLoaded;
      
      if (event.selectedDate == null) {
        emit(currentState.copyWith(
          filteredRequests: currentState.requests,
          selectedDate: null, // Make sure this is explicitly null
        ));
      } else {
        final filteredRequests = currentState.requests.where((request) {
          return request.date.year == event.selectedDate!.year &&
                 request.date.month == event.selectedDate!.month &&
                 request.date.day == event.selectedDate!.day;
        }).toList();
        
        emit(currentState.copyWith(
          filteredRequests: filteredRequests,
          selectedDate: event.selectedDate,
        ));
      }
    }
  }

  void _onClearApprovedDateFilter(
    ClearApprovedDateFilter event,
    Emitter<RiderApprovedRequestState> emit,
  ) {
    if (state is RiderApprovedRequestLoaded) {
      final currentState = state as RiderApprovedRequestLoaded;
      
      emit(RiderApprovedRequestLoaded(
        requests: currentState.requests,
        filteredRequests: currentState.requests,
        selectedDate: null, 
      ));
    }
  }
}
