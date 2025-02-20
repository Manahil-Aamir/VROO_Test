import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/auth_usecases.dart';
import '../event/auth_event.dart';
import '../state/auth_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase signUpUseCase;
  final SendEmailVerificationUseCase sendEmailVerificationUseCase;

  SignUpBloc({
    required this.signUpUseCase,
    required this.sendEmailVerificationUseCase
  }) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit
  ) async {
    emit(SignUpLoading());
    try {
      await signUpUseCase(event.email, event.password);
      await sendEmailVerificationUseCase();
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
}