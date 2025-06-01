import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/Appbar.dart';

class UserVerifyScreen extends StatelessWidget {
  const UserVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(heading: 'User Verification'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. We would be ensuring that the driver belongs to the same university as you.\n\n'
              '2. We will verify their university email address by sending an OTP over it.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.primaryColorDark,
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/safety/s2.png',
                  width: 300.w,
                  height: 300.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
