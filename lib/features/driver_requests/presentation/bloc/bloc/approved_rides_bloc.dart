import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_approved_rides.dart';
import '../event/approved_rides_event.dart';
import '../state/approved_rides_state.dart';


class ApprovedRidesBloc extends Bloc<ApprovedRidesEvent, ApprovedRidesState> {  
  final GetApprovedRides getApprovedRides;

  ApprovedRidesBloc({
    required this.getApprovedRides,
  }) : super(ApprovedRidesInitial()) {
    on<FetchApprovedRides>(_onFetchApprovedRides);
  }

  Future<void> _onFetchApprovedRides(
    FetchApprovedRides event,
    Emitter<ApprovedRidesState> emit,
  ) async {
    emit(ApprovedRidesLoading());
    try {
      final rides = await getApprovedRides.execute(event.driverId);
      emit(ApprovedRidesLoaded(rides));
    } catch (e) {
      emit(ApprovedRidesError(e.toString()));
    }
  }
}
