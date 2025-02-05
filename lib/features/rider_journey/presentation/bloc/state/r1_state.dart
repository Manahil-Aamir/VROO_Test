import 'package:flutter/material.dart';

import '../../../domain/entity/schedule_entity.dart';

abstract class R1State {}

class ScheduleInitial extends R1State {}

class ScheduleSaving extends R1State {}

class ScheduleSaved extends R1State {
  final ScheduleEntity savedSchedule;

  ScheduleSaved(this.savedSchedule);
}

class ScheduleError extends R1State {
  final String error;

  ScheduleError(this.error);
}

class ScheduleLoading extends R1State {}

class ScheduleLoaded extends R1State {
  final ScheduleEntity loadedSchedule;

  ScheduleLoaded(this.loadedSchedule);
}

class ScheduleInputState extends R1State {
  final DateTime? selectedDate;
  final TimeOfDay? minPickUpTime;
  final TimeOfDay? maxPickUpTime;
  final TimeOfDay? maxArrivalTime;
  final bool dateError;
  final bool minTimeError;
  final bool maxTimeError;
  final bool arrivalTimeError;
  final Set<String>? selectedDays;
  final DateTime? endDate;
  final String? recurrenceType;

  ScheduleInputState({
    this.selectedDate,
    this.minPickUpTime,
    this.maxPickUpTime,
    this.maxArrivalTime,
    this.dateError = false,
    this.minTimeError = false,
    this.maxTimeError = false,
    this.arrivalTimeError = false,
    this.selectedDays,
    this.endDate,
    this.recurrenceType,
  });

  ScheduleInputState copyWith({
    DateTime? selectedDate,
    TimeOfDay? minPickUpTime,
    TimeOfDay? maxPickUpTime,
    TimeOfDay? maxArrivalTime,
    Set<String>? selectedDays,
    String? recurrenceType,
    DateTime? endDate,
    bool? dateError,
    bool? minTimeError,
    bool? maxTimeError,
    bool? arrivalTimeError,
  }) {
    return ScheduleInputState(
      selectedDate: selectedDate ?? this.selectedDate,
      minPickUpTime: minPickUpTime ?? this.minPickUpTime,
      maxPickUpTime: maxPickUpTime ?? this.maxPickUpTime,
      maxArrivalTime: maxArrivalTime ?? this.maxArrivalTime,
      selectedDays: selectedDays ?? this.selectedDays,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      endDate: endDate ?? this.endDate,
      dateError: dateError ?? this.dateError,
      minTimeError: minTimeError ?? this.minTimeError,
      maxTimeError: maxTimeError ?? this.maxTimeError,
      arrivalTimeError: arrivalTimeError ?? this.arrivalTimeError,
    );
  }
}
