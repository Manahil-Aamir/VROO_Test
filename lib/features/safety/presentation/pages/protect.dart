import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/Appbar.dart';

class ProtectScreen extends StatelessWidget {
  const ProtectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(heading: 'Track Location'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. You can send your live location to your desired contacts.\n\n'
              '2. You can add your emergency contacts by going in the ‘Emergency’ section.\n\n'
              '3. You can send an ‘SOS’ call and message through the ‘SOS’ button on the menu bar.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.primaryColorDark,
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/safety/s3.png',
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
