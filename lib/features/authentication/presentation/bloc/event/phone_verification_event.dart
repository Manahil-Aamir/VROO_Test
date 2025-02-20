sealed class PhoneVerificationEvent {}

final class SendOtpEvent extends PhoneVerificationEvent {
  final String phoneNumber;

  SendOtpEvent(this.phoneNumber);
}

final class VerifyOtpEvent extends PhoneVerificationEvent {
  final String verificationId;
  final String smsCode;

  VerifyOtpEvent(this.verificationId, this.smsCode);
}