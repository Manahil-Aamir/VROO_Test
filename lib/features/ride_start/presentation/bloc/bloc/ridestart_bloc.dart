import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../authentication/domain/usecases/get_token_usecase.dart';
import '../../../domain/repository/ridestart_repository.dart';
import '../../../domain/usecases/start_ride.dart';
import '../event/ridestart_event.dart';
import '../state/ridestart_state.dart';

class RideStartBloc extends Bloc<RideStartEvent, RideStartState> {
  final StartRide repository;
  final GetTokenUseCase getTokenUseCase;
  String? _rideId;

  RideStartBloc({
    required this.repository,
    required this.getTokenUseCase,
  }) : super(RideStartInitial()) {
    on<InitializeRideEvent>(_onInitializeRide);
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
}
