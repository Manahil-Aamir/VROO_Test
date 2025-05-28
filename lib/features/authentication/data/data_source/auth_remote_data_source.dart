import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<User> signUpWithEmailAndPassword(String email, String password);
  Future<void> sendEmailVerification();
  Future<bool> checkEmailVerification();
}

class FirebaseAuthDataSource implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  @override
  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user!;
  }

  @override
  Future<void> sendEmailVerification() =>
      _firebaseAuth.currentUser!.sendEmailVerification();

  @override
  Future<bool> checkEmailVerification() async {
    try {
      // Get current user
      var user = _firebaseAuth.currentUser;

      if (user == null) {
        throw Exception('No user found');
      }

      // Reload user data from Firebase to get the latest verification status
      await user.reload();

      // Get fresh user instance with updated data
      user = _firebaseAuth.currentUser;

      if (user == null) {
        throw Exception('User session expired');
      }

      // Return the current email verification status
      return user.emailVerified;
    } on FirebaseAuthException catch (e) {
      throw Exception('Firebase Auth Error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to check email verification: ${e.toString()}');
    }
  }
}
