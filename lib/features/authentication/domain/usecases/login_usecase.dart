import 'package:vroo_test/features/authentication/domain/repository/sign_in_repository.dart';

class LoginUseCase {
  final SignInRepository repository;

  LoginUseCase({required this.repository});

  Future<void> call(String email, String password) {
    return repository.login(email, password);
  }
}
