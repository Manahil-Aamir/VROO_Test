import 'package:flutter/material.dart';

class Schedule {
  final String fromDescription;
  final String toDescription;
  final DateTime date;
  final TimeOfDay minTime;
  final TimeOfDay maxTime;
  final String recurrenceType;
  final List<String>? selectedDays;
  final DateTime? endDate;

  Schedule({
    required this.fromDescription,
    required this.toDescription,
    required this.date,
    required this.minTime,
    required this.maxTime,
    required this.recurrenceType,
    this.selectedDays,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromDescription': fromDescription,
      'toDescription': toDescription,
      'date': date.toIso8601String(),
      'minTime':
          '${minTime.hour.toString().padLeft(2, '0')}:${minTime.minute.toString().padLeft(2, '0')}',
      'maxTime':
          '${maxTime.hour.toString().padLeft(2, '0')}:${maxTime.minute.toString().padLeft(2, '0')}',
      'recurrenceType': recurrenceType,
      'selectedDays': selectedDays,
      'endDate': endDate?.toIso8601String(),
    };
  }
}
