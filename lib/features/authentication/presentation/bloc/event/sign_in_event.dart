import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends SignInEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class ForgotPasswordEvent extends SignInEvent {
  final String email;

  ForgotPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}
