import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vroo_test/features/authentication/data/model/user_model.dart';
import 'package:vroo_test/features/authentication/domain/repository/user_repository.dart';

import '../data_source/create_user_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final FirebaseMessaging firebaseMessaging; // Add FirebaseMessaging dependency

  UserRepositoryImpl(this.remoteDataSource, this.firebaseMessaging);

  @override
  Future<Map<String, dynamic>> createUser(UserModel user, String token) async {
    final fcmToken = await firebaseMessaging.getToken();
    return remoteDataSource.createUser(user, token, fcmToken!);
  }
}
