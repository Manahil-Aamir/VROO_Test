import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/sign_up/presentation/widgets/verify_button.dart';

import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/appbar_no_icon.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../bloc/bloc/email_verification_bloc.dart';
import '../bloc/event/email_verification_event.dart';
import '../bloc/state/email_verification_state.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBarNoIcon(heading: 'Email Verification'),
      body: BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
        listener: (context, state) {
          if (state is EmailVerificationSuccess) {
            context.read<Navigation>().navigateTo('/profile');
            // Navigator.pushReplacementNamed(context, Routes.profile);
          } else if (state is EmailVerificationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: theme.indicatorColor,
                duration: Duration(seconds: 3),
              ),
            );
          } else if (state is EmailVerificationResent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Verification email resent!'),
                backgroundColor: theme.secondaryHeaderColor,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Card(
                  color: theme.scaffoldBackgroundColor,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mark_email_unread,
                            size: 64.r, color: theme.primaryColor),
                        SizedBox(height: 24.h),
                        Text(
                          'Verify Your Email',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: theme.primaryColorDark,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            "We've sent a verification link to your email address. "
                            "Please check your inbox and follow the instructions.",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.primaryColorDark.withOpacity(0.8),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        GradientButton(
                          onTap: () => context
                              .read<EmailVerificationBloc>()
                              .add(EmailVerificationCheckRequested()),
                          text: 'Check Verification',
                        ),
                        SizedBox(height: 18.h),
                        Text(
                          'Didn\'t receive the email?',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.primaryColorDark,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ResendButton(
                          onTap: () => context
                              .read<EmailVerificationBloc>()
                              .add(EmailVerificationResendRequested()),
                          text: 'Resend Verify Email',
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
