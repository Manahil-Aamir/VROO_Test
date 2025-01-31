import 'package:vroo_test/features/rider_journey/data/model/schedule_model.dart';
import '../repository/r1_repository.dart';

class SaveScheduleUseCase {
  final R1Repository repository;

  SaveScheduleUseCase(this.repository);

  Future<void> execute(ScheduleModel schedule) {
    return repository.saveSchedule(schedule.toMap());
  }
}

class LoadScheduleUseCase {
  final R1Repository repository;

  LoadScheduleUseCase(this.repository);

  Future<ScheduleModel?> execute() async {
    final scheduleData = await repository.loadSchedule();
    if (scheduleData != null) {
      return ScheduleModel.fromMap(scheduleData);
    }
    return null;
  }
}
