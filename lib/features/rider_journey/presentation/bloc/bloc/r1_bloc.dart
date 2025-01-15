import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/r1_usecase.dart';
import '../event/r1_event.dart';
import '../state/r1_state.dart';

class R1Bloc extends Bloc<R1Event, R1State> {
  final SaveScheduleUseCase useCase;

  R1Bloc(this.useCase) : super(ScheduleInitial()) {
    on<SaveScheduleEvent>((event, emit) async {
      emit(ScheduleSaving());
      try {
        await useCase.execute(event.schedule);
        emit(ScheduleSaved());
      } catch (e) {
        emit(ScheduleError(e.toString()));
      }
    });
  }
}
