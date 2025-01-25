import 'package:flutter/material.dart';
import '../../../domain/entity/schedule_model.dart';

abstract class D1Event {}

class SaveScheduleEvent extends D1Event {
  final Schedule schedule;

  SaveScheduleEvent(this.schedule);
}

class LoadScheduleEvent extends D1Event {
  LoadScheduleEvent();
}

class SelectDateEvent extends D1Event {
  final DateTime selectedDate;

  SelectDateEvent(this.selectedDate);
}

class SelectTimeEvent extends D1Event {
  final TimeOfDay selectedTime;
  final String field; // e.g., "minPickUpTime", "maxPickUpTime", or "maxArrivalTime"

  SelectTimeEvent(this.selectedTime, this.field);
}

class ShowErrorEvent extends D1Event {
  final bool? dateError;
  final bool? timeError;
  final bool? maxArrivalTimeError;

  ShowErrorEvent({
    this.dateError,
    this.timeError,
    this.maxArrivalTimeError,
  });
}

class UpdateScheduleEvent extends D1Event {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final TimeOfDay? maxArrivalTime;

  UpdateScheduleEvent({
    this.selectedDate,
    this.selectedTime,
    this.maxArrivalTime,
  });

  List<Object?> get props =>
      [selectedDate, selectedTime, maxArrivalTime];
}

class ResetStateEvent extends D1Event {
  List<Object?> get props => [];
}
