import '../model/schedule_model.dart';
import '../repository/r1_repository.dart';

class SaveScheduleUseCase {
  final R1Repository repository;

  SaveScheduleUseCase(this.repository);

  Future<void> execute(Schedule schedule) {
    return repository.saveSchedule(schedule.toMap());
  }
}
