import 'package:vroo_test/features/authentication/domain/repository/sign_in_repository.dart';
import '../../data/model/user_model.dart';

class LoginUseCase {
  final SignInRepository repository;

  LoginUseCase({required this.repository});

  Future<UserModel> call(String email, String password) {
    return repository.login(email, password);
  }
}
