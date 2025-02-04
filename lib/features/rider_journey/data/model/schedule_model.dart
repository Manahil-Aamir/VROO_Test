import 'package:flutter/material.dart';
import '../../domain/entity/schedule_entity.dart';

class ScheduleModel extends ScheduleEntity {
  ScheduleModel({
    required super.fromDescription,
    required super.toDescription,
    required super.toPlaceId,
    required super.fromPlaceId,
    required super.date,
    required super.minTime,
    required super.maxTime,
    required super.arrivalTime,
    required super.recurrenceType,
    super.selectedDays,
    super.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromDescription': fromDescription,
      'toDescription': toDescription,
      'toPlaceId': toPlaceId,
      'fromPlaceId': fromPlaceId,
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

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    print('Schedule Map: $map');
    return ScheduleModel(
      fromDescription: map['fromDescription'] ?? '',
      toDescription: map['toDescription'] ?? '',
      toPlaceId: map['toPlaceId'] ?? '',
      fromPlaceId: map['fromPlaceId'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      minTime: TimeOfDay(
        hour: int.parse((map['minTime'] ?? '00:00').split(':')[0]),
        minute: int.parse((map['minTime'] ?? '00:00').split(':')[1]),
      ),
      maxTime: TimeOfDay(
        hour: int.parse((map['maxTime'] ?? '00:00').split(':')[0]),
        minute: int.parse((map['maxTime'] ?? '00:00').split(':')[1]),
      ),
      arrivalTime: TimeOfDay(
        hour: int.parse((map['arrivalTime'] ?? '00:00').split(':')[0]),
        minute: int.parse((map['arrivalTime'] ?? '00:00').split(':')[1]),
      ),
      recurrenceType: map['recurrenceType'] ?? '',
      selectedDays: List<String>.from(map['selectedDays'] ?? []),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }
}
