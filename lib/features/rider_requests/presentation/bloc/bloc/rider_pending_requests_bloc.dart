import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_pending_ride_requests.dart';
import '../events/rider_pending_requests_event.dart';
import '../states/rider_pending_requests_state.dart';

class RiderPendingRequestBloc extends Bloc<RiderPendingRequestEvent, RiderPendingRequestState> {
  final GetPendingRequestsUseCase getPendingRequestsUseCase;

  RiderPendingRequestBloc({required this.getPendingRequestsUseCase})
      : super(RiderPendingRequestInitial()) {
    on<FetchPendingRequests>(_onFetchPendingRequests);
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
}
