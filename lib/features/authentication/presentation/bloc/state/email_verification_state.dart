import 'package:equatable/equatable.dart';

abstract class EmailVerificationState extends Equatable {
  const EmailVerificationState();
}

class EmailVerificationInitial extends EmailVerificationState {
  @override
  List<Object> get props => [];
}

class EmailVerificationLoading extends EmailVerificationState {
  @override
  List<Object> get props => [];
}

class EmailVerificationSuccess extends EmailVerificationState {
  @override
  List<Object> get props => [];
}

class EmailVerificationFailure extends EmailVerificationState {
  final String error;
  const EmailVerificationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class EmailVerificationResent extends EmailVerificationState {
  @override
  List<Object> get props => [];
}