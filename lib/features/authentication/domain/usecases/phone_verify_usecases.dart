// domain/usecases/send_otp_usecase.dart
import '../repository/phone_verification_repository.dart';

class SendOtpUseCase {
  final PhoneVerificationRepository repository;
  SendOtpUseCase(this.repository);
  Future<String> call(String phoneNumber) => repository.sendOtp(phoneNumber);
}

// domain/usecases/verify_otp_usecase.dart
class VerifyOtpUseCase {
  final PhoneVerificationRepository repository;
  VerifyOtpUseCase(this.repository);
  Future<void> call(String verificationId, String smsCode) => repository.verifyOtp(verificationId, smsCode);
}