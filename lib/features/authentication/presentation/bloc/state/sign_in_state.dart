import 'package:equatable/equatable.dart';

import '../../../data/model/user_model.dart';

abstract class SignInState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends SignInState {}

class AuthLoading extends SignInState {}

class AuthLoginSuccess extends SignInState {
  final UserModel user;

  AuthLoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthLoginFailure extends SignInState {
  final String error;

  AuthLoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class AuthPasswordResetSuccess extends SignInState {}

class AuthPasswordResetFailure extends SignInState {
  final String error;

  AuthPasswordResetFailure(this.error);

  @override
  List<Object?> get props => [error];
}
