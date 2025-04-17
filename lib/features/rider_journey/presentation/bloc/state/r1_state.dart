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

  final String? dateErrorText;
  final String? minTimeErrorText;
  final String? maxTimeErrorText;
  final String? arrivalTimeErrorText;
  final String? minMaxTimeErrorText;
  final String? maxArrivalTimeErrorText;

  final Set<String>? selectedDays;
  final DateTime? endDate;
  final String? recurrenceType;

  ScheduleInputState({
    this.selectedDate,
    this.minPickUpTime,
    this.maxPickUpTime,
    this.maxArrivalTime,
    this.dateErrorText,
    this.minTimeErrorText,
    this.maxTimeErrorText,
    this.arrivalTimeErrorText,
    this.minMaxTimeErrorText,
    this.maxArrivalTimeErrorText,
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
    String? dateErrorText,
    String? minTimeErrorText,
    String? maxTimeErrorText,
    String? arrivalTimeErrorText,
    String? minMaxTimeErrorText,
    String? maxArrivalTimeErrorText,
  }) {
    return ScheduleInputState(
      selectedDate: selectedDate ?? this.selectedDate,
      minPickUpTime: minPickUpTime ?? this.minPickUpTime,
      maxPickUpTime: maxPickUpTime ?? this.maxPickUpTime,
      maxArrivalTime: maxArrivalTime ?? this.maxArrivalTime,
      selectedDays: selectedDays ?? this.selectedDays,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      endDate: endDate ?? this.endDate,
      dateErrorText: dateErrorText ?? this.dateErrorText,
      minTimeErrorText: minTimeErrorText ?? this.minTimeErrorText,
      maxTimeErrorText: maxTimeErrorText ?? this.maxTimeErrorText,
      arrivalTimeErrorText: arrivalTimeErrorText ?? this.arrivalTimeErrorText,
      minMaxTimeErrorText: minMaxTimeErrorText ?? this.minMaxTimeErrorText,
      maxArrivalTimeErrorText:
          maxArrivalTimeErrorText ?? this.maxArrivalTimeErrorText,
    );
  }
}
