import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/auth_usecases.dart';
import '../event/email_verification_event.dart';
import '../state/email_verification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  final CheckEmailVerificationUseCase checkEmailVerification;
  final SendEmailVerificationUseCase sendEmailVerification;

  EmailVerificationBloc({
    required this.checkEmailVerification,
    required this.sendEmailVerification,
  }) : super(EmailVerificationInitial()) {
    on<EmailVerificationCheckRequested>(_onVerificationCheck);
    on<EmailVerificationResendRequested>(_onResendRequest);
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
