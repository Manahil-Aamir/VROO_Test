import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../rider_journey/data/model/matching_rides_model.dart';
import '../../../domain/usecase/modify_ride_usecase.dart';
import '../../../domain/usecase/send_join_request_usecase.dart';
import '../event/matching_event.dart';
import '../state/matching_state.dart';

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
      final updatedRides =
          await modifyRideUseCase.execute(event.id, event.modifyData);
      final rides =
          updatedRides.map((ride) => MatchingRideModel.fromMap(ride)).toList();
      print('updatinggg rides');
      print(updatedRides);
      emit(RiderRequestLoaded(
        // timeWindow: newTimeWindow,
        matchingRides: rides,
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
