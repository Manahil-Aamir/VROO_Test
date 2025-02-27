import 'package:firebase_auth/firebase_auth.dart';

abstract class SignInDataSource {
  Future<void> login(String email, String password);
  Future<void> forgotPassword(String email);
}

class SignInDataSourceImpl implements SignInDataSource {
  final FirebaseAuth firebaseAuth;

  SignInDataSourceImpl({required this.firebaseAuth});

  @override
  Future<void> login(String email, String password) async {
    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
