import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/booking_confirmation_event.dart';
import '../state/booking_confirmation_state.dart';

class BookingConfirmationBloc
    extends Bloc<BookingConfirmationEvent, BookingConfirmationState> {
  BookingConfirmationBloc() : super(BookingConfirmationInitial()) {
    on<MatchMePressed>(_onMatchMePressed);
  }

  Future<void> _onMatchMePressed(
      MatchMePressed event, Emitter<BookingConfirmationState> emit) async {
    emit(BookingConfirmationLoading());
    try {
      // Simulate processing time (or call a use case if needed)
      await Future.delayed(const Duration(milliseconds: 300));
      emit(BookingConfirmationSuccess());
    } catch (e) {
      emit(BookingConfirmationFailure(e.toString()));
    }
  }
}
