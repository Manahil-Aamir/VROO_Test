import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/Appbar.dart';

class BeforeRideScreen extends StatelessWidget {
  const BeforeRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(heading: 'Before the Ride'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Choose your driver wisely. You can view the rider’s ratings and information before booking a ride.\n\n'
              '2. Ensure that the driver and car match the profile. Otherwise, cancel the ride',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.primaryColorDark,
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/safety/s1.png',
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
