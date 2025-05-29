import 'package:flutter/material.dart';

class ScheduleEntity {
  final String fromDescription;
  final String toDescription;
  final DateTime date;
  final TimeOfDay time;
  final TimeOfDay maxArrivalTime;
  final bool recurrenceType;
  final String? frequency;
  final Set<String>? selectedDays; // Changed to Set
  final DateTime? endDate;

  const ScheduleEntity({
    required this.fromDescription,
    required this.toDescription,
    required this.date,
    required this.time,
    required this.maxArrivalTime,
    required this.recurrenceType,
    this.frequency,
    this.selectedDays,
    this.endDate,
  });
}
