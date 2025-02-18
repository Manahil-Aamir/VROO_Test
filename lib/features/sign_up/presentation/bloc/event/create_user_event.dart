import 'package:equatable/equatable.dart';
import 'package:vroo_test/features/sign_up/data/model/user_model.dart';

sealed class CreateUserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CreateUserSubmitted extends CreateUserEvent {
  final UserModel user;

  CreateUserSubmitted({required this.user});

  @override
  List<Object?> get props => [user];
}
