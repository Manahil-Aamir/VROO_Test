import 'package:equatable/equatable.dart';

abstract class EmailVerificationEvent extends Equatable {
  const EmailVerificationEvent();
}

class EmailVerificationCheckRequested extends EmailVerificationEvent {
  @override
  List<Object> get props => [];
}

class EmailVerificationResendRequested extends EmailVerificationEvent {
  @override
  List<Object> get props => [];
}