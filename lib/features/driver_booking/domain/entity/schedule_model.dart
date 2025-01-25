import 'package:flutter/material.dart';

class Schedule {
  final String fromDescription;
  final String toDescription;
  final DateTime date;
  final TimeOfDay time;
  final TimeOfDay maxArrivalTime;
  final String recurrenceType;
  final List<String>? selectedDays;
  final DateTime? endDate;

  Schedule({
    required this.fromDescription,
    required this.toDescription,
    required this.date,
    required this.time,
    required this.maxArrivalTime,
    required this.recurrenceType,
    this.selectedDays,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromDescription': fromDescription,
      'toDescription': toDescription,
      'date': date.toIso8601String(),
      'time':
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      'maxArrivalTime':
          '${maxArrivalTime.hour.toString().padLeft(2, '0')}:${maxArrivalTime.minute.toString().padLeft(2, '0')}',
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
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0]),
        minute: int.parse(map['time'].split(':')[1]),
      ),
      maxArrivalTime: TimeOfDay(
        hour: int.parse(map['maxArrivalTime'].split(':')[0]),
        minute: int.parse(map['maxArrivalTime'].split(':')[1]),
      ),
      recurrenceType: map['recurrenceType'],
      selectedDays: List<String>.from(map['selectedDays'] ?? []),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }
}
