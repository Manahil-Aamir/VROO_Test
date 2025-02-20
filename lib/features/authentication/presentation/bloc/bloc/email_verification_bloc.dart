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
    emit(EmailVerificationLoading());
    try {
      final user = await checkEmailVerification();
      if (user.isEmailVerified) {
        print('verified');
        emit(EmailVerificationSuccess());
      } else {
        print('not verified');
        emit(EmailVerificationFailure('Email not verified yet'));
      }
    } catch (e) {
      print('failure');
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
