import '../entity/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthUser> signUpWithEmailAndPassword(String email, String password);
  Future<void> sendEmailVerification();
  Future<bool> checkEmailVerification();
  Future<void> resendVerificationEmail();
}
