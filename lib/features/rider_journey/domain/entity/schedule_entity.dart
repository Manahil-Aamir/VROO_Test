import 'package:flutter/material.dart';

class ScheduleEntity {
  final String fromDescription;
  final String toDescription;
  final DateTime date;
  final TimeOfDay minTime;
  final TimeOfDay maxTime;
  final TimeOfDay arrivalTime;
  final String recurrenceType;
  final List<String>? selectedDays;
  final DateTime? endDate;

  ScheduleEntity({
    required this.fromDescription,
    required this.toDescription,
    required this.date,
    required this.minTime,
    required this.maxTime,
    required this.arrivalTime,
    required this.recurrenceType,
    this.selectedDays,
    this.endDate,
  });
}
