import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/r1_usecase.dart';
import '../event/r1_event.dart';
import '../state/r1_state.dart';

class R1Bloc extends Bloc<R1Event, R1State> {
  final SaveScheduleUseCase saveScheduleUseCase;
  final LoadScheduleUseCase loadScheduleUseCase;

  R1Bloc(this.saveScheduleUseCase, this.loadScheduleUseCase)
      : super(ScheduleInitial()) {
    // Ensure we start with ScheduleInputState
    on<SaveScheduleEvent>((event, emit) async {
      emit(ScheduleSaving());
      try {
        await saveScheduleUseCase.execute(event.schedule);
        emit(ScheduleSaved(
            event.schedule)); // Emit saved state with the schedule
      } catch (e) {
        emit(ScheduleError(e.toString())); // Handle errors
      }
    });

    // Handling date selection event
    on<SelectDateEvent>((event, emit) {
      final currentState = state;
      if (currentState is ScheduleInputState) {
        emit(currentState.copyWith(
            selectedDate: event.selectedDate,
            dateError: false)); // Update selectedDate and clear error
      }
    });

    // Handling time selection event for different fields
    on<SelectTimeEvent>((event, emit) {
      final currentState = state;
      if (currentState is ScheduleInputState) {
        print(
            "Selected time for ${event.field}: ${event.selectedTime}"); // Debugging line
        switch (event.field) {
          case "minPickUpTime":
            emit(currentState.copyWith(
                minPickUpTime: event.selectedTime,
                minTimeError: false)); // Update minPickUpTime and clear error
            break;
          case "maxPickUpTime":
            emit(currentState.copyWith(
                maxPickUpTime: event.selectedTime,
                maxTimeError: false)); // Update maxPickUpTime and clear error
            break;
          case "maxArrivalTime":
            emit(currentState.copyWith(
                maxArrivalTime: event.selectedTime,
                arrivalTimeError:
                    false)); // Update maxArrivalTime and clear error
            break;
        }
      }
    });

    // Handling validation and error display event
    on<ShowErrorEvent>((event, emit) {
      final currentState = state;
      if (currentState is ScheduleInputState) {
        emit(currentState.copyWith(
          dateError: event.dateError ??
              currentState.dateError, // Update dateError with new value
          minTimeError: event.minTimeError ??
              currentState.minTimeError, // Update minTimeError
          maxTimeError: event.maxTimeError ??
              currentState.maxTimeError, // Update maxTimeError
          arrivalTimeError: event.arrivalTimeError ??
              currentState.arrivalTimeError, // Update arrivalTimeError
        ));
      }
    });

    // Handling loading event
    on<LoadScheduleEvent>((event, emit) async {
      emit(ScheduleLoading());
      try {
        final schedule = await loadScheduleUseCase.execute();
        if (schedule != null) {
          // Emit ScheduleInputState with the loaded schedule
          emit(ScheduleInputState(
            selectedDate: schedule.date,
            minPickUpTime: schedule.minTime,
            maxPickUpTime: schedule.maxTime,
            maxArrivalTime: schedule.arrivalTime,
            dateError: false,
            minTimeError: false,
            maxTimeError: false,
            arrivalTimeError: false,
          ));
        } else {
          // Emit ScheduleInputState with default values if no schedule is loaded
          emit(ScheduleInputState());
        }
      } catch (e) {
        emit(ScheduleError(e.toString()));
      }
    });

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

    on<ResetStateEvent>((event, emit) {
      emit(ScheduleInitial());
    });
  }
}
