import 'package:vroo_test/features/sign_up/domain/entity/user_entity.dart';

abstract class UserRepository {
  Future<void> createUser(UserEntity profile);
}