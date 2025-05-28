import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/Appbar.dart';

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
                    onTap: () => _handleFeatureTap(context, 'Before the Ride'),
                  ),
                  SafetyFeatureCard(
                    title: 'Driver Verification',
                    imagePath: 'assets/images/safety/l2.png',
                    onTap: () =>
                        _handleFeatureTap(context, 'Driver Verification'),
                  ),
                  SafetyFeatureCard(
                    title: 'Safety Features',
                    imagePath: 'assets/images/safety/l3.png',
                    onTap: () => _handleFeatureTap(context, 'Safety Features'),
                  ),
                  SafetyFeatureCard(
                    title: 'Report a Problem',
                    imagePath: 'assets/images/safety/l4.png',
                    onTap: () => _handleFeatureTap(context, 'Report a Problem'),
                  ),
                  SafetyFeatureCard(
                    title: 'Car Verification',
                    imagePath: 'assets/images/safety/l5.png',
                    onTap: () => _handleFeatureTap(context, 'Car Verification'),
                  ),
                  SafetyFeatureCard(
                    title: 'Contact',
                    imagePath: 'assets/images/safety/l6.png',
                    onTap: () => _handleFeatureTap(context, 'Contact'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFeatureTap(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature tapped'),
        duration: const Duration(seconds: 2),
      ),
    );
    // Add your navigation logic here
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => FeatureDetailScreen(feature)));
  }
}
