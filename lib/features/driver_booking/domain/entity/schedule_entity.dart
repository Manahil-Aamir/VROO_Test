import 'package:flutter/material.dart';

class ScheduleEntity {
  final String fromDescription;
  final String toDescription;
  final DateTime date;
  final TimeOfDay time;
  final TimeOfDay maxArrivalTime;
  final String recurrenceType;
  final List<String>? selectedDays;
  final DateTime? endDate;

  const ScheduleEntity({
    required this.fromDescription,
    required this.toDescription,
    required this.date,
    required this.time,
    required this.maxArrivalTime,
    required this.recurrenceType,
    this.selectedDays,
    this.endDate,
  });
}
