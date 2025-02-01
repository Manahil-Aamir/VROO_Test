import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/r2_usecase.dart';
import '../event/r2_event.dart';
import '../state/r2_state.dart';

class R2Bloc extends Bloc<R2Event, R2State> {
  final SavePreferenceUseCase savePreferenceUseCase;
  final LoadPreferenceUseCase loadPreferenceUseCase;

  R2Bloc(this.savePreferenceUseCase, this.loadPreferenceUseCase)
      : super(PreferenceInitial()) {
    // Ensure we start with PreferenceInputState
    on<SavePreferenceEvent>((event, emit) async {
      emit(PreferenceSaving());
      try {
        await savePreferenceUseCase.execute(event.preference);
        emit(PreferenceSaved(
            event.preference)); // Emit saved state with the preference
      } catch (e) {
        emit(PreferenceError(e.toString())); // Handle errors
      }
    });

    // Handling bool values event
    on<TogglePreferenceEvent>((event, emit) {
      final currentState = state;
      if (currentState is PreferenceInputState) {
        if (event.preferenceKey == "sameGender") {
          emit(currentState.copyWith(
              sameGender: !(currentState.sameGender ?? false)));
        } else if (event.preferenceKey == "walk") {
          emit(currentState.copyWith(walk: !(currentState.walk ?? false)));
        }
      }
    });

    // Handling loading event
    on<LoadPreferenceEvent>((event, emit) async {
      emit(PreferenceLoading());
      try {
        final preference = await loadPreferenceUseCase.execute();
        if (preference != null) {
          // Emit PreferenceInputState with the loaded preference
          emit(PreferenceInputState(
            sameGender: preference.sameGender,
            walk: preference.walk,
          ));
        } else {
          // Emit PreferenceInputState with default values if no preference is loaded
          emit(PreferenceInputState());
        }
      } catch (e) {
        emit(PreferenceError(e.toString()));
      }
    });

    on<UpdatePreferenceEvent>((event, emit) {
      final currentState = state;
      if (currentState is PreferenceInputState) {
        emit(currentState.copyWith(
          sameGender: event.sameGender ?? currentState.sameGender,
          walk: event.walk ?? currentState.walk,
        ));
      }
    });

    on<ResetStateEvent>((event, emit) {
      emit(PreferenceInitial());
    });
  }
}
