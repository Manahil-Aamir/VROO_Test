import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/r1_usecase.dart';
import '../event/r1_event.dart';
import '../state/r1_state.dart';

class R1Bloc extends Bloc<R1Event, R1State> {
  final SaveScheduleUseCase saveScheduleUseCase;
  final LoadScheduleUseCase loadScheduleUseCase;

  R1Bloc(this.saveScheduleUseCase, this.loadScheduleUseCase)
      : super(ScheduleInitial()) {
    // Save schedule event
    on<SaveScheduleEvent>((event, emit) async {
      emit(ScheduleSaving());
      try {
        await saveScheduleUseCase.execute(event.schedule);
        emit(ScheduleSaved(event.schedule));
      } catch (e) {
        emit(ScheduleError(e.toString()));
      }
    });

    // Update recurrence info
    on<UpdateRecurrenceEvent>((event, emit) {
      if (state is ScheduleInputState) {
        final currentState = state as ScheduleInputState;
        emit(currentState.copyWith(
          recurrenceType: event.recurrenceType,
          selectedDays: event.selectedDays,
          endDate: event.endDate,
        ));
      }
    });

    // Select date
    on<SelectDateEvent>((event, emit) {
      final currentState = state;
      if (currentState is ScheduleInputState) {
        emit(currentState.copyWith(
          selectedDate: event.selectedDate,
          dateErrorText: null, // clear error on success
        ));
      }
    });

    // Select time
    on<SelectTimeEvent>((event, emit) {
      final currentState = state;
      if (currentState is ScheduleInputState) {
        switch (event.field) {
          case "minPickUpTime":
            emit(currentState.copyWith(
              minPickUpTime: event.selectedTime,
              minTimeErrorText: null,
              minMaxTimeErrorText: null,
            ));
            break;
          case "maxPickUpTime":
            emit(currentState.copyWith(
              maxPickUpTime: event.selectedTime,
              maxTimeErrorText: null,
              minMaxTimeErrorText: null,
            ));
            break;
          case "maxArrivalTime":
            emit(currentState.copyWith(
              maxArrivalTime: event.selectedTime,
              arrivalTimeErrorText: null,
              maxArrivalTimeErrorText: null,
            ));
            break;
        }
      }
    });

    // Show validation errors
    on<ShowErrorEvent>((event, emit) {
      final currentState = state;
      if (currentState is ScheduleInputState) {
        emit(currentState.copyWith(
          dateErrorText: event.dateErrorText ?? currentState.dateErrorText,
          minTimeErrorText:
              event.minTimeErrorText ?? currentState.minTimeErrorText,
          maxTimeErrorText:
              event.maxTimeErrorText ?? currentState.maxTimeErrorText,
          arrivalTimeErrorText:
              event.arrivalTimeErrorText ?? currentState.arrivalTimeErrorText,
          minMaxTimeErrorText:
              event.minMaxTimeErrorText ?? currentState.minMaxTimeErrorText,
          maxArrivalTimeErrorText: event.maxArrivalTimeErrorText ??
              currentState.maxArrivalTimeErrorText,
        ));
      }
    });

    // Load saved schedule or use defaults
    on<LoadScheduleEvent>((event, emit) async {
      emit(ScheduleLoading());
      try {
        final schedule = await loadScheduleUseCase.execute();
        if (schedule != null) {
          emit(ScheduleInputState(
            selectedDate: schedule.date,
            minPickUpTime: schedule.minTime,
            maxPickUpTime: schedule.maxTime,
            maxArrivalTime: schedule.arrivalTime,
          ));
        } else {
          emit(ScheduleInputState()); // default blank state
        }
      } catch (e) {
        emit(ScheduleError(e.toString()));
      }
    });

    // Update schedule fields directly
    on<UpdateScheduleEvent>((event, emit) {
      final currentState = state;
      if (currentState is ScheduleInputState) {
        emit(currentState.copyWith(
          selectedDate: event.selectedDate ?? currentState.selectedDate,
          minPickUpTime: event.minPickUpTime ?? currentState.minPickUpTime,
          maxPickUpTime: event.maxPickUpTime ?? currentState.maxPickUpTime,
          maxArrivalTime: event.maxArrivalTime ?? currentState.maxArrivalTime,
        ));
      }
    });

    // Reset to initial
    on<ResetStateEvent>((event, emit) {
      emit(ScheduleInitial());
    });
  }
}
