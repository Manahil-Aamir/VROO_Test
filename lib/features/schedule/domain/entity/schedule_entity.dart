import '../../../../shared/domain/entity/location_entity.dart';

class ScheduleEntity {
  final String id;
  final LocationEntity source;
  final LocationEntity destination;
  final List<String> days;
  final DateTime time;
  final DateTime endingDate;
  final String frequency;

  const ScheduleEntity({
    required this.id,
    required this.source,
    required this.destination,
    required this.days,
    required this.time,
    required this.endingDate,
    required this.frequency
  });
}
