import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../authentication/domain/usecases/get_token_usecase.dart';
import '../../../domain/usecases/give_review.dart';
import '../../../domain/usecases/start_ride.dart';
import '../../../domain/usecases/end_ride.dart';
import '../../../domain/usecases/updatepassenger.dart';
import '../event/ridestart_event.dart';
import '../state/ridestart_state.dart';

class RideStartBloc extends Bloc<RideStartEvent, RideStartState> {
  final StartRide repository;
  final GetTokenUseCase getTokenUseCase;
  final GiveReview giveReviewUseCase;
  final UpdatePassenger updatePassengerUseCase;
  final EndRide endRideUseCase;
  String? _rideId;

  RideStartBloc({
    required this.repository,
    required this.getTokenUseCase,
    required this.giveReviewUseCase,
    required this.updatePassengerUseCase,
    required this.endRideUseCase,
  }) : super(RideStartInitial()) {
    on<InitializeRideEvent>(_onInitializeRide);
    on<SubmitReviewEvent>(_onSubmitReview);
    on<UpdatePassengerEvent>(_onUpdatePassenger);
    on<EndRideEvent>(_onEndRide);
  }

  Future<void> _onInitializeRide(
    InitializeRideEvent event,
    Emitter<RideStartState> emit,
  ) async {
    emit(RideStartLoading());
    _rideId = event.rideId;
    await _startRide(emit);
  }

  Future<void> _startRide(Emitter<RideStartState> emit) async {
    try {
      // Get auth token
      final tokenResult = await getTokenUseCase();
      if (tokenResult == null) {
        throw Exception('Token result is null');
      }
      final token =
          tokenResult; // Assuming getTokenUseCase returns a String token directly

      // Start ride with token and rideId
      final rideData = await repository.call(_rideId!, token);
      emit(RideStartSuccess(rideData));
    } catch (e) {
      emit(RideStartFailure(e.toString()));
    }
  }

  Future<void> _onSubmitReview(
    SubmitReviewEvent event,
    Emitter<RideStartState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      // Get auth token
      final tokenResult = await getTokenUseCase();
      if (tokenResult == null) {
        throw Exception('Token result is null');
      }
      final token = tokenResult;

      if (_rideId == null) {
        throw Exception('Ride ID is not initialized');
      }

      // Submit review
      final reviewData = await giveReviewUseCase.call(event.reviewModel, token);
      emit(ReviewSuccess(reviewData));
    } catch (e) {
      emit(ReviewFailure(e.toString()));
    }
  }

  Future<void> _onUpdatePassenger(
    UpdatePassengerEvent event,
    Emitter<RideStartState> emit,
  ) async {
    emit(UpdatePassengerLoading());
    try {
      // Get auth token
      final tokenResult = await getTokenUseCase();
      if (tokenResult == null) {
        throw Exception('Token result is null');
      }
      final token = tokenResult;

      if (_rideId == null) {
        throw Exception('Ride ID is not initialized');
      }

      // Update passenger
      final passengerData = await updatePassengerUseCase.call(
        _rideId!,
        event.passengerId,
        event.action,
        token,
      );
      emit(UpdatePassengerSuccess(passengerData));
    } catch (e) {
      emit(UpdatePassengerFailure(e.toString()));
    }
  }

  Future<void> _onEndRide(
    EndRideEvent event,
    Emitter<RideStartState> emit,
  ) async {
    emit(EndRideLoading());
    try {
      // Get auth token
      final tokenResult = await getTokenUseCase();
      if (tokenResult == null) {
        throw Exception('Token result is null');
      }
      final token = tokenResult;

      if (_rideId == null) {
        throw Exception('Ride ID is not initialized');
      }

      // End ride
      final endRideData = await endRideUseCase.call(_rideId!, token);
      emit(EndRideSuccess(endRideData));
    } catch (e) {
      emit(EndRideFailure(e.toString()));
    }
  }
}
