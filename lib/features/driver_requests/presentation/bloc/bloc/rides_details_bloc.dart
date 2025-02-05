import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_rides_details.dart';
import '../event/rides_details_event.dart';
import '../state/rides_details_state.dart';


class RideDetailsBloc extends Bloc<RideDetailsEvent, RideDetailsState> {
  final GetRideDetails getRideDetails;

  RideDetailsBloc(this.getRideDetails) : super(RideDetailsInitial()) {
    on<FetchRideDetails>(_onFetchRideDetails);
  }

  Future<void> _onFetchRideDetails(
    FetchRideDetails event,
    Emitter<RideDetailsState> emit,
  ) async {
    emit(RideDetailsLoading());
    try {
      final rides = await getRideDetails.execute(event.driverId);
      emit(RideDetailsLoaded(rides));
    } catch (e) {
      emit(RideDetailsError(e.toString()));
    }
  }
}
