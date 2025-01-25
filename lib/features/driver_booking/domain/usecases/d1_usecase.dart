import '../entity/schedule_model.dart';
import '../repository/d1_repository.dart';

class SaveScheduleUseCase {
  final D1Repository repository;

  SaveScheduleUseCase(this.repository);

  Future<void> execute(Schedule schedule) {
    return repository.saveSchedule(schedule.toMap());
  }
}

class LoadScheduleUseCase {
  final D1Repository repository;

  LoadScheduleUseCase(this.repository);

  Future<Schedule?> execute() async {
    final scheduleData = await repository.loadSchedule();
    if (scheduleData != null) {
      return Schedule.fromMap(scheduleData);
    }
    return null;
  }
}
