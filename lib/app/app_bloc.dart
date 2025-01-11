import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<AppStarted>((event, emit) {
      // Handle the AppStarted event and emit a new state
      // For example:
      // emit(AppLoaded());
    });

    // Add handlers for other events as needed
  }
}
