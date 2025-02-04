abstract class BookingConfirmationState {}

class BookingConfirmationInitial extends BookingConfirmationState {}

class BookingConfirmationLoading extends BookingConfirmationState {}

class BookingConfirmationSuccess extends BookingConfirmationState {}

class BookingConfirmationFailure extends BookingConfirmationState {
  final String error;
  BookingConfirmationFailure(this.error);
}
