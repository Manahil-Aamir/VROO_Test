import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/features/sign_up/domain/entity/user_entity.dart';
import '../bloc/bloc/create_user_bloc.dart';
import '../bloc/bloc/phone_verification_bloc.dart';
import '../bloc/event/create_user_event.dart';
import '../bloc/event/phone_verification_event.dart';
import '../bloc/state/create_user_state.dart';
import '../bloc/state/phone_verification_state.dart';

class CreateUserScreen extends StatelessWidget {
  // final String email; 
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // CreateUserScreen({required this.email, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete CreateUser')),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PhoneVerificationBloc, PhoneVerificationState>(
            listener: (context, state) {
              if (state is PhoneVerificationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
          ),
          BlocListener<CreateUserBloc, CreateUserState>(
            listener: (context, state) {
              if (state is CreateUserSuccess) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: genderController,
                decoration: InputDecoration(labelText: 'Gender')),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone Number')),
              
              BlocBuilder<PhoneVerificationBloc, PhoneVerificationState>(
                builder: (context, state) {
                  if (state is PhoneVerificationCodeSent) {
                    return Column(
                      children: [
                        TextField(
                          controller: otpController,
                          decoration: InputDecoration(labelText: 'OTP')),
                        ElevatedButton(
                          onPressed: () => context.read<PhoneVerificationBloc>()
                            .add(VerifyOtpEvent(state.verificationId, otpController.text)),
                          child: const Text('Verify OTP')),
                      ],
                    );
                  }
                  return ElevatedButton(
                    onPressed: () => context.read<PhoneVerificationBloc>()
                      .add(SendOtpEvent(phoneController.text)),
                    child: const Text('Send OTP'));
                },
              ),
              
              BlocBuilder<PhoneVerificationBloc, PhoneVerificationState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is PhoneVerificationSuccess
                        ? () => _submitCreateUser(context)
                        : null,
                    child: const Text('Complete Registration'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitCreateUser(BuildContext context) {
    //final authUser = context.read<AuthRepository>().getCurrentUser();
    final CreateUser = UserEntity(
      email: '',//email,
      gender: genderController.text,
      phoneNumber: phoneController.text,
    );
    context.read<CreateUserBloc>().add(CreateUserSubmitted(CreateUser));
  }
}