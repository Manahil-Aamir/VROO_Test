import '../repository/schedule_repository.dart';

class DeleteSchedule {
  final ScheduleRepository repository;

  DeleteSchedule(this.repository);

  Future<void> call(String id, String role) async {
    return await repository.deleteSchedule(id, role);
  }
}