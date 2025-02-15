import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/bloc/email_verification_bloc.dart';
import '../bloc/event/email_verification_event.dart';

class VerifyButton extends StatelessWidget {
  const VerifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 50.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.secondaryHeaderColor,
            theme.secondaryHeaderColor.withOpacity(0.5),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () => context
            .read<EmailVerificationBloc>()
            .add(EmailVerificationCheckRequested()),
        child: Text(
          'Check Verification',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.primaryColorDark,
          ),
        ),
      ),
    );
  }
}
