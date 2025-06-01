import '../../../../shared/data/models/location_modal.dart';
import '../../domain/entity/schedule_entity.dart';

class ScheduleModel {
  final String id;
  final LocationModel source;
  final LocationModel destination;
  final List<String> days;
  final DateTime time;
  final DateTime endingDate;
  final String frequency;

  ScheduleModel({
    required this.id, 
    required this.source, 
    required this.destination, 
    required this.days, 
    required this.time, 
    required this.endingDate,
    required this.frequency
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    final timeString = json['departureTime'] ?? 
                     json['pickupTimeRange']['min'];
    
    return ScheduleModel(
      id: json['recurring_id'],
      source: LocationModel.fromJson(json['source']),
      destination: LocationModel.fromJson(json['destination']),
      days: (json['customDays'] as List).cast<String>(),
      time: DateTime.parse(timeString),
      endingDate: DateTime.parse(json['endOn']),
      frequency: json['frequency'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recurring_id': id,
      'source': source.toJson(),
      'destination': destination.toJson(),
      'customDays': days,
      'departureTime': time.toIso8601String(),
      'endOn': endingDate.toIso8601String(),
      'frequency': frequency,
    };
  }

  ScheduleEntity toEntity() {
    return ScheduleEntity(
      id: id,
      source: source.toEntity(),
      destination: destination.toEntity(),
      days: days,
      time: time,
      endingDate: endingDate,
      frequency: frequency
    );
  }
}