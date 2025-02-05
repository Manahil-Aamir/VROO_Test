import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/D1_usecase.dart';
import '../event/d1_event.dart';
import '../state/d1_state.dart';

class D1Bloc extends Bloc<D1Event, D1State> {
  final SaveScheduleUseCase saveScheduleUseCase;
  final LoadScheduleUseCase loadScheduleUseCase;

  D1Bloc(this.saveScheduleUseCase, this.loadScheduleUseCase)
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
          case "time":
            emit(currentState.copyWith(
                selectedTime: event.selectedTime,
                timeError: false)); // Update PickUpTime and clear error
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
          timeError: event.timeError ??
              currentState.timeError, // Update timeError
          arrivalTimeError: event.maxArrivalTimeError ??
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
            selectedTime: schedule.time,
            maxArrivalTime: schedule.maxArrivalTime,
            dateError: false,
            timeError: false,
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
          selectedTime: event.selectedTime ?? currentState.selectedTime,
          maxArrivalTime: event.maxArrivalTime ?? currentState.maxArrivalTime,
        ));
      }
    });

    on<ResetStateEvent>((event, emit) {
      emit(ScheduleInitial());
    });
  }
}
