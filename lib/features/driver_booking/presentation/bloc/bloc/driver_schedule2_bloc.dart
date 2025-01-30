import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entity/driver_schedule2_entity.dart';
import '../../../domain/usecases/driver_schedule2_usecase.dart';
import '../event/driver_schedule2_event.dart';
import '../state/driver_schedule2_state.dart';

class CarPreferencesBloc extends Bloc<CarPreferencesEvent, CarPreferencesState> {
  final SaveCarPreferencesUseCase saveUseCase;
  final LoadCarPreferencesUseCase loadUseCase;

  CarPreferencesBloc(this.saveUseCase, this.loadUseCase)
      : super(CarPreferencesInitial()) {
    on<LoadCarPreferencesEvent>(_onLoadPreferences);
    on<SaveCarPreferencesEvent>(_onSavePreferences);
  }

  void _onLoadPreferences(
    LoadCarPreferencesEvent event,
    Emitter<CarPreferencesState> emit,
  ) async {
    emit(CarPreferencesLoading());
    try {
      final preferences = await loadUseCase.execute();
      emit(preferences != null
          ? CarPreferencesLoaded(preferences)
          : CarPreferencesLoaded(CarPreferencesEntity(
              availableSeats: 2,
              sameGenderOnly: false,
            )));
    } catch (e) {
      emit(CarPreferencesError(e.toString()));
    }
  }

  void _onSavePreferences(
    SaveCarPreferencesEvent event,
    Emitter<CarPreferencesState> emit,
  ) async {
    try {
      await saveUseCase.execute(event.preferences);
      emit(CarPreferencesLoaded(event.preferences));
    } catch (e) {
      emit(CarPreferencesError(e.toString()));
    }
  }
}