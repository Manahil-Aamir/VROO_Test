import 'package:flutter_bloc/flutter_bloc.dart';
import 'driver_home_event.dart';
import 'driver_home_state.dart';

class DriverHomeBloc extends Bloc<DriverHomeEvent, DriverHomeState> {
  DriverHomeBloc() : super(DriverHomeInitial());

  @override
  Stream<DriverHomeState> mapEventToState(DriverHomeEvent event) async* {
    if (event is SelectStartingPoint) {
      yield DriverHomeLoading();
      try {
        // Handle starting point logic (if needed)
        yield DriverHomePointSelected(event.pointType, event.location);
      } catch (error) {
        yield DriverHomeError("Failed to select starting point");
      }
    } else if (event is SelectDestinationPoint) {
      yield DriverHomeLoading();
      try {
        // Handle destination point logic (if needed)
        yield DriverHomePointSelected(event.pointType, event.location);
      } catch (error) {
        yield DriverHomeError("Failed to select destination");
      }
    }
  }
}
