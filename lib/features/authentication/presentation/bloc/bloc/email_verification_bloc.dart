import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/auth_usecases.dart';
import '../event/email_verification_event.dart';
import '../state/email_verification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  final CheckEmailVerificationUseCase checkEmailVerification;
  final SendEmailVerificationUseCase sendEmailVerification;
  final DeleteUserUseCase deleteUserUseCase;

  EmailVerificationBloc({
    required this.checkEmailVerification,
    required this.sendEmailVerification,
    required this.deleteUserUseCase,
  }) : super(EmailVerificationInitial()) {
    on<EmailVerificationCheckRequested>(_onVerificationCheck);
    on<EmailVerificationResendRequested>(_onResendRequest);
    on<EmailVerificationDeleteUserRequested>(_onDeleteUser);
  }

  Future<void> _onVerificationCheck(
    EmailVerificationCheckRequested event,
    Emitter<EmailVerificationState> emit,
  ) async {
    try {
      final isEmailVerified = await checkEmailVerification();
      if (isEmailVerified) {
        print('verified');
        emit(EmailVerificationSuccess());
      } else {
        print('not verified');
        // Don't emit failure for automatic checks - just silently continue
        // Only the success state matters for navigation
      }
    } catch (e) {
      print('failure: $e');
      // Only emit failure for serious errors, not for "not verified" status
      emit(EmailVerificationFailure(e.toString()));
    }
  }

  Future<void> _onDeleteUser(
    EmailVerificationDeleteUserRequested event,
    Emitter<EmailVerificationState> emit,
  ) async {
    try {
      await deleteUserUseCase();
      emit(EmailVerificationUserDeleted());
    } catch (e) {
      print('Error deleting user: $e');
      // Optionally emit failure state
    }
  }

  Future<void> _onResendRequest(
    EmailVerificationResendRequested event,
    Emitter<EmailVerificationState> emit,
  ) async {
    emit(EmailVerificationLoading());
    try {
      await sendEmailVerification();
      emit(EmailVerificationResent());
    } catch (e) {
      emit(EmailVerificationFailure(e.toString()));
    }
  }
}
