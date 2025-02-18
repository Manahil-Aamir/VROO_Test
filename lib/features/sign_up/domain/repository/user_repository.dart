import '../../data/model/user_model.dart';

abstract class UserRepository {
  Future<Map<String, dynamic>> createUser(UserModel user, String token);
}
