import 'package:vroo_test/features/authentication/domain/repository/sign_in_repository.dart';

class ForgotPasswordUseCase {
  final SignInRepository repository;

  ForgotPasswordUseCase({required this.repository});

  Future<void> call(String email) {
    return repository.forgotPassword(email);
  }
}
