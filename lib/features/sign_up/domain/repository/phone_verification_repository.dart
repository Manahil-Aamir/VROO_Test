abstract class PhoneVerificationRepository {
  Future<String> sendOtp(String phoneNumber);
  Future<void> verifyOtp(String verificationId, String smsCode);
}
