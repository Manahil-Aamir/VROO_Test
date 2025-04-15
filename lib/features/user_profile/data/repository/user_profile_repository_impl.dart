import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/user_profile.dart';
import '../../domain/repository/user_profile_repository.dart';
import '../data_source/user_profile_remote_datasource.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;
  final FirebaseAuth firebaseAuth;

  UserProfileRepositoryImpl(
      {required this.remoteDataSource, required this.firebaseAuth});

  Future<String> getToken() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        final token = await user.getIdToken();
        return token!;
      } catch (e) {
        throw Exception("Failed to get token: ${e.toString()}");
      }
    } else {
      throw Exception("User not logged in");
    }
  }

  @override
  Future<UserProfile> getUserProfile() async {
    return await remoteDataSource.getUserProfile(await getToken());
  }

  @override
  Future<UserProfile> updateUserProfile(
      {String? name, String? phoneNumber}) async {
    return await remoteDataSource.updateUserProfile(
        name: name, phoneNumber: phoneNumber, token: await getToken());
  }
}
