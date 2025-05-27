import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entity/user_profile.dart';
import '../../domain/repository/user_profile_repository.dart';
import '../data_source/user_profile_remote_datasource.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;
  final FirebaseAuth firebaseAuth;

  UserProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.firebaseAuth,
  });

  Future<String> getToken() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        final token = await user.getIdToken();
        print('[UserProfileRepositoryImpl] Token fetched: $token');
        return token!;
      } catch (e) {
        print('[UserProfileRepositoryImpl] Failed to get token: $e');
        throw Exception("Failed to get token: ${e.toString()}");
      }
    } else {
      print('[UserProfileRepositoryImpl] No user logged in.');
      throw Exception("User not logged in");
    }
  }

  @override
  Future<UserProfile> getUserProfile() async {
    print('[UserProfileRepositoryImpl] Getting user profile...');
    final token = await getToken();
    final profile = await remoteDataSource.getUserProfile(token);
    print('[UserProfileRepositoryImpl] Retrieved user profile: $profile');
    return profile;
  }

  @override
  Future<UserProfile> updateUserProfile({String? name, String? phoneNumber}) async {
    print('[UserProfileRepositoryImpl] Updating user profile with name: $name, phone: $phoneNumber');
    final token = await getToken();
    final updatedProfile = await remoteDataSource.updateUserProfile(
      name: name,
      phoneNumber: phoneNumber,
      token: token,
    );
    print('[UserProfileRepositoryImpl] Updated profile: $updatedProfile');
    return updatedProfile;
  }
}
