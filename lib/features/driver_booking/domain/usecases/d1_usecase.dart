import 'package:vroo_test/features/driver_booking/data/model/schedule_model.dart';
import '../repository/d1_repository.dart';

class SaveScheduleUseCase {
  final D1Repository repository;

  SaveScheduleUseCase(this.repository);

  Future<void> execute(ScheduleModel schedule) async {
    try {
      final scheduleMap = schedule.toMap();
      print('Saving schedule: $scheduleMap'); // Debug log
      await repository.saveSchedule(scheduleMap);
    } catch (e) {
      print('Error in SaveScheduleUseCase: $e');
      rethrow;
    }
  }
}

class LoadScheduleUseCase {
  final D1Repository repository;

  LoadScheduleUseCase(this.repository);

  Future<ScheduleModel?> execute() async {
    try {
      final scheduleData = await repository.loadSchedule();
      print('Loaded schedule data: $scheduleData'); // Debug log
      
      if (scheduleData != null) {
        final scheduleModel = ScheduleModel.fromMap(scheduleData);
        print('Created schedule model: ${scheduleModel.toMap()}'); // Debug log
        return scheduleModel;
      }
      return null;
    } catch (e) {
      print('Error in LoadScheduleUseCase: $e');
      rethrow;
    }
  }
}
