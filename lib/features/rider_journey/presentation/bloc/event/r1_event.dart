import '../../../domain/model/schedule_model.dart';

abstract class R1Event {}

class SaveScheduleEvent extends R1Event {
  final Schedule schedule;

  SaveScheduleEvent(this.schedule);
}
