import 'package:flutter/material.dart';

class ScheduleEntity {
  final DateTime date;
  final TimeOfDay minTime;
  final TimeOfDay maxTime;
  final TimeOfDay arrivalTime;
  final bool recurrenceType;
  final String? frequency;
  final Set<String>? selectedDays; // Changed to Set
  final DateTime? endDate;

  ScheduleEntity({
    required this.date,
    required this.minTime,
    required this.maxTime,
    required this.arrivalTime,
    required this.recurrenceType,
    this.frequency,
    this.selectedDays,
    this.endDate,
  });
}
