import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/Appbar.dart';

import '../../../../core/router/navigation.dart';
import '../widgets/safetycard.dart';

class SafetyFeaturesScreen extends StatelessWidget {
  const SafetyFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(heading: 'Safety'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'How you are protected',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColorDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                childAspectRatio: 1,
                children: [
                  SafetyFeatureCard(
                      title: 'Before the Ride',
                      imagePath: 'assets/images/safety/l1.png',
                      onTap: () {
                        context.read<Navigation>().navigateTo('/before_ride');
                      }),
                  SafetyFeatureCard(
                      title: 'User Verification',
                      imagePath: 'assets/images/safety/l2.png',
                      onTap: () {
                        context.read<Navigation>().navigateTo('/user_verify');
                      }),
                  SafetyFeatureCard(
                      title: 'Location Tracking',
                      imagePath: 'assets/images/safety/l3.png',
                      onTap: () {
                        context.read<Navigation>().navigateTo('/protect');
                      }),
                  SafetyFeatureCard(
                      title: 'Report a Problem',
                      imagePath: 'assets/images/safety/l4.png',
                      onTap: () {
                        context.read<Navigation>().navigateTo('/report');
                      }),
                  SafetyFeatureCard(
                      title: 'Route Check',
                      imagePath: 'assets/images/safety/l5.png',
                      onTap: () {
                        context.read<Navigation>().navigateTo('/route');
                      }),
                  SafetyFeatureCard(
                      title: 'Safe Contact',
                      imagePath: 'assets/images/safety/l6.png',
                      onTap: () {
                        context.read<Navigation>().navigateTo('/safecontact');
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
