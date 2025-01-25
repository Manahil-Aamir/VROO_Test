import 'package:flutter/material.dart';
import '../../../domain/entity/schedule_model.dart';

abstract class D1State {}

class ScheduleInitial extends D1State {}

class ScheduleSaving extends D1State {}

class ScheduleSaved extends D1State {
  final Schedule savedSchedule;

  ScheduleSaved(this.savedSchedule);
}

class ScheduleError extends D1State {
  final String error;

  ScheduleError(this.error);
}

class ScheduleLoading extends D1State {}

class ScheduleLoaded extends D1State {
  final Schedule loadedSchedule;

  ScheduleLoaded(this.loadedSchedule);
}

class ScheduleInputState extends D1State {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final TimeOfDay? maxArrivalTime;
  final bool dateError;
  final bool timeError;
  final bool arrivalTimeError;

  ScheduleInputState({
    this.selectedDate,
    this.selectedTime,
    this.maxArrivalTime,
    this.dateError = false,
    this.timeError = false,
    this.arrivalTimeError = false,
  });

  ScheduleInputState copyWith({
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    TimeOfDay? maxArrivalTime,
    bool? dateError,
    bool? timeError,
    bool? arrivalTimeError,
  }) {
    return ScheduleInputState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      maxArrivalTime: maxArrivalTime ?? this.maxArrivalTime,
      dateError: dateError ?? this.dateError,
      timeError: timeError ?? this.timeError,
      arrivalTimeError: arrivalTimeError ?? this.arrivalTimeError,
    );
  }
}
