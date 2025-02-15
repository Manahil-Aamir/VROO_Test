import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repository/phone_verification_repository.dart';
import '../data_source/phone_verification_data_source.dart';

class PhoneVerificationRepositoryImpl implements PhoneVerificationRepository {
  final PhoneVerificationRemoteDataSource remoteDataSource;

  PhoneVerificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> sendOtp(String phoneNumber) => remoteDataSource.sendOtp(phoneNumber);

  @override
  Future<void> verifyOtp(String verificationId, String smsCode) async {
    try {
      await remoteDataSource.verifyOtp(verificationId, smsCode);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        throw Exception('This phone number is already registered');
      }
      if (e.code == 'credential-already-in-use') {
        throw Exception('Phone number already used by another account');
      }
      rethrow;
    }
  }
}
