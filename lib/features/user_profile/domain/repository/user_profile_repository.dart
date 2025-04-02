import '../entity/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile> getUserProfile();
}
