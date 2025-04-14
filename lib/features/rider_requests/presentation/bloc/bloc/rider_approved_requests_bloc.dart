import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_approved_ride_requests.dart';
import '../events/rider_approved_requests_event.dart';
import '../states/rider_approved_requests_state.dart';

class RiderApprovedRequestBloc extends Bloc<RiderApprovedRequestEvent, RiderApprovedRequestState> {
  final GetApprovedRequestsUseCase getApprovedRequestsUseCase;

  RiderApprovedRequestBloc({required this.getApprovedRequestsUseCase})
      : super(RiderApprovedRequestInitial()) {
    on<FetchApprovedRequests>(_onFetchApprovedRequests);
  }

  Future<void> _onFetchApprovedRequests(
    FetchApprovedRequests event,
    Emitter<RiderApprovedRequestState> emit,
  ) async {
    emit(RiderApprovedRequestLoading());
    try {
      final requests = await getApprovedRequestsUseCase.execute();
      emit(RiderApprovedRequestLoaded(requests));
    } catch (e) {
      emit(RiderApprovedRequestError(e.toString()));
    }
  }
}
