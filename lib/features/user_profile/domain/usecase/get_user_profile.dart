import '../entity/user_profile.dart';
import '../repository/user_profile_repository.dart';

class GetUserProfile {
  final UserProfileRepository repository;

  GetUserProfile(this.repository);

  Future<UserProfile> call() async {
    return await repository.getUserProfile();
  }
}
