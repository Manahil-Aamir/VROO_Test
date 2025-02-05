import 'package:vroo_test/features/driver_booking/data/model/schedule_model.dart';
import '../repository/d1_repository.dart';

class SaveScheduleUseCase {
  final D1Repository repository;

  SaveScheduleUseCase(this.repository);

  Future<void> execute(ScheduleModel schedule) {
    return repository.saveSchedule(schedule.toMap());
  }
}

class LoadScheduleUseCase {
  final D1Repository repository;

  LoadScheduleUseCase(this.repository);

  Future<ScheduleModel?> execute() async {
    final scheduleData = await repository.loadSchedule();
    if (scheduleData != null) {
      return ScheduleModel.fromMap(scheduleData);
    }
    return null;
  }
}
