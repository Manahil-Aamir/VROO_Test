import '../entity/schedule_entity.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleEntity>> getSchedules(String role);
  Future<void> deleteSchedule(String id, String role);
}