import 'package:vroo_test/features/sign_up/domain/entity/user_entity.dart';

import '../repository/user_repository.dart';

class CreateUserUseCase {
  final UserRepository repository;
  CreateUserUseCase(this.repository);
  Future<void> call(UserEntity profile) => repository.createUser(profile);
}