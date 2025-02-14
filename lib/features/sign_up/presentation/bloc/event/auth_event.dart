// Events
import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String password;

  const SignUpSubmitted(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}