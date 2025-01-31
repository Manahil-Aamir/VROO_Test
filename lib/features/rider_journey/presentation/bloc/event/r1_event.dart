import 'package:flutter/material.dart';

import '../../../domain/entity/schedule_model.dart';

abstract class R1Event {}

class SaveScheduleEvent extends R1Event {
  final Schedule schedule;

  SaveScheduleEvent(this.schedule);
}

class LoadScheduleEvent extends R1Event {
  LoadScheduleEvent();
}

class SelectDateEvent extends R1Event {
  final DateTime selectedDate;

  SelectDateEvent(this.selectedDate);
}

class SelectTimeEvent extends R1Event {
  final TimeOfDay selectedTime;
  final String
      field; // e.g., "minPickUpTime", "maxPickUpTime", or "maxArrivalTime"

  SelectTimeEvent(this.selectedTime, this.field);
}

class ShowErrorEvent extends R1Event {
  final bool? dateError;
  final bool? minTimeError;
  final bool? maxTimeError;
  final bool? arrivalTimeError;
  final bool? minMaxTimeError;
  final bool? maxArrivalTimeError;

  ShowErrorEvent({
    this.dateError,
    this.minTimeError,
    this.maxTimeError,
    this.arrivalTimeError,
    this.minMaxTimeError,
    this.maxArrivalTimeError,
  });
}

class UpdateScheduleEvent extends R1Event {
  final DateTime? selectedDate;
  final TimeOfDay? minPickUpTime;
  final TimeOfDay? maxPickUpTime;
  final TimeOfDay? maxArrivalTime;

  UpdateScheduleEvent({
    this.selectedDate,
    this.minPickUpTime,
    this.maxPickUpTime,
    this.maxArrivalTime,
  });

  List<Object?> get props =>
      [selectedDate, minPickUpTime, maxPickUpTime, maxArrivalTime];
}

class ResetStateEvent extends R1Event {
  List<Object?> get props => [];
}
