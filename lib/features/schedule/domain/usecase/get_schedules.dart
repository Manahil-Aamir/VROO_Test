import '../entity/schedule_entity.dart';
import '../repository/schedule_repository.dart';

class GetSchedules {
  final ScheduleRepository repository;

  GetSchedules(this.repository);

  Future<List<ScheduleEntity>> call(String role) async {
    return await repository.getSchedules(role);
  }
}
