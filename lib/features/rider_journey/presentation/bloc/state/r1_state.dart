abstract class R1State {}

class ScheduleInitial extends R1State {}

class ScheduleSaving extends R1State {}

class ScheduleSaved extends R1State {}

class ScheduleError extends R1State {
  final String error;

  ScheduleError(this.error);
}
