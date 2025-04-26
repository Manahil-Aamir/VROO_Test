import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_ride_request_joins.dart';
import '../events/ride_request_join_event.dart';
import '../states/ride_request_join_state.dart';

class RideRequestJoinBloc extends Bloc<RideRequestJoinEvent, RideRequestJoinState> {
  final GetPendingRideRequestJoinsUsecase getPendingRideRequestJoinsUsecase;

  RideRequestJoinBloc(this.getPendingRideRequestJoinsUsecase) : super(RideRequestJoinInitial()) {
    on<FetchPendingRideRequestJoins>(_onFetchPendingRideRequestJoins);
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
}
