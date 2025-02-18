import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class TokenRemoteDataSource {
  Future<String?> fetchToken();
}

class TokenRemoteDataSourceImpl implements TokenRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  TokenRemoteDataSourceImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<String?> fetchToken() async {
    try {
      // Reload user to get updated verification status
      await _firebaseAuth.currentUser?.reload();
      final user = _firebaseAuth.currentUser;

      if (user != null && user.emailVerified) {
        // Generate Firebase ID token
        final idToken = await user.getIdToken(true);
        debugPrint('Firebase ID token: $idToken');
        return idToken;
      } else {
        throw Exception("User not verified or not logged in");
      }
    } catch (e) {
      debugPrint("Error fetching token: $e");
      return null;
    }
  }
}
