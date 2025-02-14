import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  final String? email;
  final bool isEmailVerified;

  AuthModel({required this.email, required this.isEmailVerified});

  factory AuthModel.fromFirebaseUser(User user) => AuthModel(
    email: user.email,
    isEmailVerified: user.emailVerified
  );
}