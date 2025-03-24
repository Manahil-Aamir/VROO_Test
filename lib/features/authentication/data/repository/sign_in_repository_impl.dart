import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vroo_test/features/authentication/data/data_source/sign_in_data_source.dart';
import '../../domain/repository/sign_in_repository.dart';
import '../data_source/backend_login_data_source.dart';

class SignInRepositoryImpl implements SignInRepository {
  final SignInDataSource dataSource;
  final FirebaseAuth firebaseAuth;
  final BackendLoginDataSource backendLoginDataSource;
  final FirebaseMessaging firebaseMessaging; // Add FirebaseMessaging dependency

  SignInRepositoryImpl({
    required this.dataSource,
    required this.firebaseAuth,
    required this.backendLoginDataSource,
    required this.firebaseMessaging,
  });

  @override
  Future<void> login(String email, String password) async {
    await dataSource.login(email, password); // Firebase login

    // Get user after successful login
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception("User not found after login");
    }

    // Get ID token
    final token = await user.getIdToken();

    // Get FCM token
    final fcmToken = await firebaseMessaging.getToken();

    // Notify backend with both tokens
    await backendLoginDataSource.notifyLogin(token ?? '', fcmToken ?? '');
  }

  @override
  Future<void> forgotPassword(String email) {
    return dataSource.forgotPassword(email);
  }
}
