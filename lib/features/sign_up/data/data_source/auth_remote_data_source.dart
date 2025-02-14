import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<User> signUpWithEmailAndPassword(String email, String password);
  Future<void> sendEmailVerification();
  Future<User> checkEmailVerification();
  Future<void> reloadUser();
}

class FirebaseAuthDataSource implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  @override
  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
    return userCredential.user!;
  }

  @override
  Future<void> sendEmailVerification() => _firebaseAuth.currentUser!.sendEmailVerification();

  @override
  Future<User> checkEmailVerification() async {
    await reloadUser();
    return _firebaseAuth.currentUser!;
  }

  @override
  Future<void> reloadUser() => _firebaseAuth.currentUser!.reload();
}