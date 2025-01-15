import 'package:flutter/material.dart';

class Schedule {
  final String fromDescription;
  final String toDescription;
  final DateTime date;
  final TimeOfDay minTime;
  final TimeOfDay maxTime;
  final String recurrence;

  Schedule({
    required this.fromDescription,
    required this.toDescription,
    required this.date,
    required this.minTime,
    required this.maxTime,
    required this.recurrence,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromDescription': fromDescription,
      'toDescription': toDescription,
      'date': date.toIso8601String(),
      'minTime': '${minTime.hour}:${minTime.minute}',
      'maxTime': '${maxTime.hour}:${maxTime.minute}',
      'recurrence': recurrence,
    };
  }
}
