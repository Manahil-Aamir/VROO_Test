import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/features/matching/presentation/bloc/event/matching_event.dart';
import 'package:vroo_test/features/matching/presentation/bloc/state/matching_state.dart';
import '../../../domain/usecase/modify_ride_usecase.dart';
import '../../../domain/usecase/send_join_request_usecase.dart';

class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  final ModifyRideUseCase modifyRideUseCase;
  final SendJoinRequestUseCase sendJoinRequestUseCase;

  MatchingBloc(
    this.modifyRideUseCase,
    this.sendJoinRequestUseCase,
  ) : super(const RiderRequestInitial(timeWindow: 0, matchingRides: [])) {
    on<ModifyTimeWindowEvent>(_onModifyTimeWindow);
    on<JoinRideRequestEvent>(_onJoinRide);
  }

  Future<void> _onModifyTimeWindow(
      ModifyTimeWindowEvent event, Emitter<MatchingState> emit) async {
    emit(RiderRequestLoading());
    try {
      // The UI sends all parameters needed in modifyData.
      final updatedRides = await modifyRideUseCase.execute(event.modifyData);
      // Assume that modifyData contains a 'timeWindow' key (of type int).
      int newTimeWindow = event.modifyData['timeWindow'] as int;
      emit(RiderRequestLoaded(
        // timeWindow: newTimeWindow,
        matchingRides: updatedRides['matchingRides'],
      ));
    } catch (e) {
      emit(RiderRequestError(e.toString()));
    }
  }

  Future<void> _onJoinRide(
      JoinRideRequestEvent event, Emitter<MatchingState> emit) async {
    emit(RiderJoinLoading());
    try {
      // Pass the joinData map directly to the join use case.
      final rideDetails = await sendJoinRequestUseCase.execute(event.joinData);

      emit(RiderJoinSuccess(rideDetails));
    } catch (e) {
      emit(RiderRequestError(e.toString()));
    }
  }
}
