import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/user_profile.dart';
import '../../domain/repository/user_profile_repository.dart';
import '../data_source/user_profile_remote_datasource.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;
  final FirebaseAuth firebaseAuth;

  UserProfileRepositoryImpl({required this.remoteDataSource, required this.firebaseAuth});

  @override
  Future<UserProfile> getUserProfile() async {
    final user = firebaseAuth.currentUser!;
    return await remoteDataSource.getUserProfile(user.uid);
  }
}
