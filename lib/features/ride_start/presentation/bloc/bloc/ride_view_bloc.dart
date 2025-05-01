import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/features/ride_start/domain/usecases/rider_view.dart';
import 'package:vroo_test/features/ride_start/presentation/bloc/event/rideview_event.dart';
import 'package:vroo_test/features/ride_start/presentation/bloc/state/rideview_state.dart';

import '../../../../authentication/domain/usecases/get_token_usecase.dart';

class RideViewBloc extends Bloc<RideViewEvent, RideViewState> {
  final RiderViewUseCase repository;
  final GetTokenUseCase getTokenUseCase;
  String? _rideId;

  RideViewBloc({
    required this.repository,
    required this.getTokenUseCase,
  }) : super(RideViewInitial()) {
    on<InitializeRideViewEvent>(_onInitializeRide);
  }

  Future<void> _onInitializeRide(
    InitializeRideViewEvent event,
    Emitter<RideViewState> emit,
  ) async {
    emit(RideViewLoading());
    _rideId = event.rideId;
    await _startRide(emit);
  }

  Future<void> _startRide(Emitter<RideViewState> emit) async {
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
      emit(RideViewSuccess(rideData));
    } catch (e) {
      emit(RideViewFailure(e.toString()));
    }
  }
}
