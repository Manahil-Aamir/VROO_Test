import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

abstract class PhoneVerificationRemoteDataSource {
  Future<String> sendOtp(String phoneNumber);
  Future<void> verifyOtp(String verificationId, String smsCode);
}

class FirebasePhoneVerificationDataSource 
    implements PhoneVerificationRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebasePhoneVerificationDataSource(this._firebaseAuth);

  @override
  Future<String> sendOtp(String phoneNumber) async {
    final completer = Completer<String>();
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (_) {},
      verificationFailed: (e) => completer.completeError(e),
      codeSent: (verificationId, _) => completer.complete(verificationId),
      codeAutoRetrievalTimeout: (_) {},
    );
    print('sent');
    return completer.future;
  }

  @override
  Future<void> verifyOtp(String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to verify phone number');
    }
    
    await user.linkWithCredential(credential);
  }
}
