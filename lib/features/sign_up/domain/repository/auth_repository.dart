import  '../entity/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthUser> signUpWithEmailAndPassword(String email, String password);
  Future<void> sendEmailVerification();
  Future<AuthUser> checkEmailVerification();
  Future<void> resendVerificationEmail();
  Future<void> reloadUser();
}