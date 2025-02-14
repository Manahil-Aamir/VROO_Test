import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/navigation.dart';
import '../bloc/bloc/email_verification_bloc.dart';
import '../bloc/event/email_verification_event.dart';
import '../bloc/state/email_verification_state.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
        listener: (context, state) {
          if (state is EmailVerificationSuccess) {
            context.read<Navigation>().navigateTo('/profile');
            // Navigator.pushReplacementNamed(context, Routes.profile);
          } else if (state is EmailVerificationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is EmailVerificationResent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Verification email resent!')),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Check your email for verification link'),
                ElevatedButton(
                  onPressed: () => context
                      .read<EmailVerificationBloc>()
                      .add(EmailVerificationCheckRequested()),
                  child: const Text('Check Verification'),
                ),
                TextButton(
                  onPressed: () => context
                      .read<EmailVerificationBloc>()
                      .add(EmailVerificationResendRequested()),
                  child: const Text('Resend Verification Email'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}