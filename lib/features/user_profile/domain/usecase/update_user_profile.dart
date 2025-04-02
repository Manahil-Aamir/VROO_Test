import '../entity/user_profile.dart';
import '../repository/user_profile_repository.dart';

class UpdateUserProfile {
  final UserProfileRepository repository;

  UpdateUserProfile(this.repository);

  Future<UserProfile> call({String? name, String? phoneNumber}) async {
    return await repository.updateUserProfile(name: name, phoneNumber: phoneNumber);
  }
}
