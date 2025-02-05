import 'package:flutter/material.dart';
import '../../domain/entity/schedule_entity.dart';

class ScheduleModel extends ScheduleEntity {
  const ScheduleModel({
    required String fromDescription,
    required String toDescription,
    required DateTime date,
    required TimeOfDay time,
    required TimeOfDay maxArrivalTime,
    required String recurrenceType,
    List<String>? selectedDays,
    DateTime? endDate,
  }) : super(
          fromDescription: fromDescription,
          toDescription: toDescription,
          date: date,
          time: time,
          maxArrivalTime: maxArrivalTime,
          recurrenceType: recurrenceType,
          selectedDays: selectedDays,
          endDate: endDate,
        );

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
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
      selectedDays: map['selectedDays'] != null
          ? List<String>.from(map['selectedDays'])
          : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }

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
}
