import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/matching_rides_model.dart';
import '../../../domain/usecase/get_ride_request_matches_usecase.dart';
import '../../../domain/usecase/modify_ride_usecase.dart';
import '../../../domain/usecase/send_join_request_usecase.dart';
import '../event/matching_event.dart';
import '../state/matching_state.dart';

class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  final ModifyRideUseCase modifyRideUseCase;
  final SendJoinRequestUseCase sendJoinRequestUseCase;
  final GetRideRequestMatchesUseCase getRideRequestMatchesUseCase;

  MatchingBloc(
    this.modifyRideUseCase,
    this.sendJoinRequestUseCase,
    this.getRideRequestMatchesUseCase,
  ) : super(const RiderRequestInitial(timeWindow: 0, matchingRides: [])) {
    on<ModifyTimeWindowEvent>(_onModifyTimeWindow);
    on<JoinRideRequestEvent>(_onJoinRide);
    on<FetchRideRequestMatchesEvent>(_onFetchRideRequestMatches);
    on<ToggleMatchesVisibility>(_onToggleMatchesVisibility);
  }

  Future<void> _onModifyTimeWindow(
      ModifyTimeWindowEvent event, Emitter<MatchingState> emit) async {
    emit(RiderRequestLoading());
    try {
      final updatedRides =
          await modifyRideUseCase.execute(event.id, event.modifyData);
      final rides =
          updatedRides.map((ride) => MatchingRideModel.fromJson(ride)).toList();
      emit(RiderRequestLoaded(matchingRides: rides));
    } catch (e) {
      emit(RiderRequestError(e.toString()));
    }
  }

  Future<void> _onJoinRide(
      JoinRideRequestEvent event, Emitter<MatchingState> emit) async {
    emit(RiderJoinLoading());
    try {
      final rideDetails = await sendJoinRequestUseCase.execute(event.joinData);
      emit(RiderJoinSuccess(rideDetails));
    } catch (e) {
      emit(RiderRequestError(e.toString()));
    }
  }

  Future<void> _onFetchRideRequestMatches(
      FetchRideRequestMatchesEvent event, Emitter<MatchingState> emit) async {
    print('Processing FetchRideRequestMatchesEvent for ID: ${event.rideRequestId}');
    // Change this to MatchesLoading so the UI can detect it properly
    emit(MatchesLoading());
    try {
      print('Calling getRideRequestMatchesUseCase.execute()');
      final matches = await getRideRequestMatchesUseCase.execute(event.rideRequestId);
      print('Received ${matches.length} matches');
      emit(RideRequestMatchesLoaded(matches: matches));
    } catch (e) {
      print('Error in _onFetchRideRequestMatches: $e');
      emit(RiderRequestError(e.toString()));
    }
  }

  Future<void> _onToggleMatchesVisibility(
    ToggleMatchesVisibility event, Emitter<MatchingState> emit) async {
    // Get the current matches, regardless of current state
    List<MatchingRideModel> currentMatches = [];
    
    if (state is RideRequestMatchesLoaded) {
      currentMatches = (state as RideRequestMatchesLoaded).matches;
    } else if (state is MatchesVisibilityToggled) {
      currentMatches = (state as MatchesVisibilityToggled).matches;
    }
    
    // If we're showing matches but don't have any yet, should trigger loading
    if (event.showMatches && currentMatches.isEmpty) {
      // You might want to fetch matches here or inform the user
      print('No matches available to show');
    }
    
    emit(MatchesVisibilityToggled(
      showMatches: event.showMatches,
      matches: currentMatches,
    ));
  }
}
