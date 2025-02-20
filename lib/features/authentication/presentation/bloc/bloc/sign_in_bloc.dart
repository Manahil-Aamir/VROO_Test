import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/features/authentication/presentation/bloc/event/sign_in_event.dart';
import 'package:vroo_test/features/authentication/presentation/bloc/state/sign_in_state.dart';
import '../../../domain/usecases/forget_password_usecase.dart';
import '../../../domain/usecases/login_usecase.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final LoginUseCase loginUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  SignInBloc({
    required this.loginUseCase,
    required this.forgotPasswordUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<ForgotPasswordEvent>(_onForgotPassword);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<SignInState> emit) async {
    emit(AuthLoading());
    try {
      await loginUseCase(event.email, event.password);
      emit(AuthLoginSuccess());
    } catch (e) {
      emit(AuthLoginFailure(e.toString()));
    }
  }

  Future<void> _onForgotPassword(
      ForgotPasswordEvent event, Emitter<SignInState> emit) async {
    emit(AuthLoading());
    try {
      await forgotPasswordUseCase(event.email);
      emit(AuthPasswordResetSuccess());
    } catch (e) {
      emit(AuthPasswordResetFailure(e.toString()));
    }
  }
}
