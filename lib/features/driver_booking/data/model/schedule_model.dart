import 'package:flutter/material.dart';
import '../../domain/entity/schedule_entity.dart';

class ScheduleModel extends ScheduleEntity {
  const ScheduleModel({
    required super.fromDescription,
    required super.toDescription,
    required super.date,
    required super.time,
    required super.maxArrivalTime,
    required super.recurrenceType,
    super.frequency,
    super.selectedDays,
    super.endDate,
  });

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
      frequency: map['frequency'],
      // Fix: Convert List back to Set
      selectedDays: map['selectedDays'] != null 
          ? Set<String>.from(map['selectedDays']) 
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
      'selectedDays': selectedDays?.toList(), // Convert Set to List for serialization
      'frequency': frequency,
      'endDate': endDate?.toIso8601String(),
    };
  }
}
