import '../../data/model/user_model.dart';
import '../repository/user_repository.dart';

class CreateUserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  Future<Map<String, dynamic>> call(UserModel user, String token) {
    return repository.createUser(user, token);
  }
}
