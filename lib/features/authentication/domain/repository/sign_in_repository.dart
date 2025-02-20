abstract class SignInRepository {
  Future<void> login(String email, String password);
  Future<void> forgotPassword(String email);
}
