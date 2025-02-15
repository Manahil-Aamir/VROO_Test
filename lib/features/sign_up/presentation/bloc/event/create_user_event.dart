import 'package:vroo_test/features/sign_up/domain/entity/user_entity.dart';

sealed class CreateUserEvent {}

final class CreateUserSubmitted extends CreateUserEvent {
  final UserEntity CreateUser;

  CreateUserSubmitted(this.CreateUser);
}