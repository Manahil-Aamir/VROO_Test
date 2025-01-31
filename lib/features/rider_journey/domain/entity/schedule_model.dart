import 'package:flutter/material.dart';

class Schedule {
  final String fromDescription;
  final String toDescription;
  final DateTime date;
  final TimeOfDay minTime;
  final TimeOfDay maxTime;
  final TimeOfDay arrivalTime;
  final String recurrenceType;
  final List<String>? selectedDays;
  final DateTime? endDate;

  Schedule({
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

  Map<String, dynamic> toMap() {
    return {
      'fromDescription': fromDescription,
      'toDescription': toDescription,
      'date': date.toIso8601String(),
      'minTime':
          '${minTime.hour.toString().padLeft(2, '0')}:${minTime.minute.toString().padLeft(2, '0')}',
      'maxTime':
          '${maxTime.hour.toString().padLeft(2, '0')}:${maxTime.minute.toString().padLeft(2, '0')}',
      'arrivalTime':
          '${arrivalTime.hour.toString().padLeft(2, '0')}:${arrivalTime.minute.toString().padLeft(2, '0')}',
      'recurrenceType': recurrenceType,
      'selectedDays': selectedDays,
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      fromDescription: map['fromDescription'],
      toDescription: map['toDescription'],
      date: DateTime.parse(map['date']),
      minTime: TimeOfDay(
        hour: int.parse(map['minTime'].split(':')[0]),
        minute: int.parse(map['minTime'].split(':')[1]),
      ),
      maxTime: TimeOfDay(
        hour: int.parse(map['maxTime'].split(':')[0]),
        minute: int.parse(map['maxTime'].split(':')[1]),
      ),
      arrivalTime: TimeOfDay(
        hour: int.parse(map['arrivalTime'].split(':')[0]),
        minute: int.parse(map['arrivalTime'].split(':')[1]),
      ),
      recurrenceType: map['recurrenceType'],
      selectedDays: List<String>.from(map['selectedDays'] ?? []),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }
}
