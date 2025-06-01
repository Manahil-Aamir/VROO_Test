import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/delete_schedule.dart';
import '../../../domain/usecase/get_schedules.dart';
import '../event/schedule_event.dart';
import '../state/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetSchedules getSchedules;
  final DeleteSchedule deleteSchedule; // Add this

  ScheduleBloc({
    required this.getSchedules,
    required this.deleteSchedule, // Add this
  }) : super(ScheduleInitial()) {
    on<LoadSchedulesEvent>(_onLoadSchedules);
    on<RefreshSchedulesEvent>(_onRefreshSchedules);
    on<DeleteScheduleEvent>(_onDeleteSchedule); // Add this handler
  }

  Future<void> _onLoadSchedules(
    LoadSchedulesEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    try {
      final schedules = await getSchedules(event.role);
      emit(ScheduleLoaded(schedules: schedules));
    } catch (e) {
      emit(ScheduleError(message: e.toString()));
    }
  }

  Future<void> _onRefreshSchedules(
    RefreshSchedulesEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      final schedules = await getSchedules(event.role);
      emit(ScheduleLoaded(schedules: schedules));
    } catch (e) {
      emit(ScheduleError(message: e.toString()));
    }
  }

  Future<void> _onDeleteSchedule(
    DeleteScheduleEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state is ScheduleLoaded) {
      final currentState = state as ScheduleLoaded;
      try {
        // final role = context.read<RoleBloc>().state.role;
        await deleteSchedule(event.id, event.role);
        
        // Update state by removing the deleted schedule
        final updatedSchedules = currentState.schedules
          .where((schedule) => schedule.id != event.id)
          .toList();
          
        emit(ScheduleLoaded(schedules: updatedSchedules));
      } catch (e) {
        emit(ScheduleError(message: 'Failed to delete schedule'));
        emit(currentState); // Revert to previous state
      }
    }
  }
}
