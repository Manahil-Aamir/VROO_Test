import '../../data/model/user_model.dart';

abstract class SignInRepository {
  Future<UserModel> login(String email, String password);
  Future<void> forgotPassword(String email);
}
