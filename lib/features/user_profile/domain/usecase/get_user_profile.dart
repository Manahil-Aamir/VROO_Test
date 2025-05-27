import '../entity/user_profile.dart';
import '../repository/user_profile_repository.dart';

class GetUserProfile {
  final UserProfileRepository repository;

  GetUserProfile(this.repository);

  Future<UserProfile> call() async {
    print('[GetUserProfile] Fetching user profile...');
    final profile = await repository.getUserProfile();
    print('[GetUserProfile] User profile fetched: $profile');
    return profile;
  }
}
