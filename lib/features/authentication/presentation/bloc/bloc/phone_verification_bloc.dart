import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/phone_verify_usecases.dart';
import '../event/phone_verification_event.dart';
import '../state/phone_verification_state.dart';

class PhoneVerificationBloc
    extends Bloc<PhoneVerificationEvent, PhoneVerificationState> {
  final SendOtpUseCase sendOtp;
  final VerifyOtpUseCase verifyOtp;
  String? _verificationId;

  PhoneVerificationBloc({required this.sendOtp, required this.verifyOtp})
      : super(PhoneVerificationInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  Future<void> _onSendOtp(
      SendOtpEvent event, Emitter<PhoneVerificationState> emit) async {
    emit(PhoneVerificationLoading());
    try {
      _verificationId = await sendOtp(event.phoneNumber);
      emit(PhoneVerificationCodeSent(_verificationId!));
    } catch (e) {
      emit(PhoneVerificationFailure(e.toString()));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<PhoneVerificationState> emit,
  ) async {
    emit(PhoneVerificationLoading());
    try {
      await verifyOtp(event.verificationId, event.smsCode);
      emit(PhoneVerificationSuccess());
      
      // // Optional: Force token refresh to update linked providers
      // await _firebaseAuth.currentUser?.getIdToken(true);
      
    } catch (e) {
      emit(PhoneVerificationFailure(e.toString()));
    }
  }
}
