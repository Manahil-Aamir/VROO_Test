import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../domain/repository/sign_in_repository.dart';
import '../data_source/backend_login_data_source.dart';
import '../data_source/sign_in_data_source.dart';
import '../model/user_model.dart';

class SignInRepositoryImpl implements SignInRepository {
  final SignInDataSource dataSource;
  final FirebaseAuth firebaseAuth;
  final BackendLoginDataSource backendLoginDataSource;
  final FirebaseMessaging firebaseMessaging;

  SignInRepositoryImpl({
    required this.dataSource,
    required this.firebaseAuth,
    required this.backendLoginDataSource,
    required this.firebaseMessaging,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    await dataSource.login(email, password);
    
    final user = firebaseAuth.currentUser;
    if (user == null) throw Exception("User not found after login");

    final token = await user.getIdToken();
    final fcmToken = await firebaseMessaging.getToken();

    return await backendLoginDataSource.notifyLogin(token ?? '', fcmToken ?? '');
  }
  
  @override
  Future<void> forgotPassword(String email) {
    return dataSource.forgotPassword(email);
  }
}

