import '../entity/auth_entity.dart';
import '../repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);
  Future<AuthUser> call(String email, String password) =>
      repository.signUpWithEmailAndPassword(email, password);
}

class SendEmailVerificationUseCase {
  final AuthRepository repository;
  SendEmailVerificationUseCase(this.repository);
  Future<void> call() => repository.sendEmailVerification();
}

class CheckEmailVerificationUseCase {
  final AuthRepository repository;
  CheckEmailVerificationUseCase(this.repository);
  Future<bool> call() => repository.checkEmailVerification();
}
