sealed class PhoneVerificationState {}

final class PhoneVerificationInitial extends PhoneVerificationState {}

final class PhoneVerificationLoading extends PhoneVerificationState {}

final class PhoneVerificationCodeSent extends PhoneVerificationState {
  final String verificationId;

  PhoneVerificationCodeSent(this.verificationId);
}

final class PhoneVerificationSuccess extends PhoneVerificationState {}

final class PhoneVerificationFailure extends PhoneVerificationState {
  final String error;

  PhoneVerificationFailure(this.error);
}
