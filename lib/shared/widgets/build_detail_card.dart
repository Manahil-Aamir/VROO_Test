import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final List<Widget> details;

  const DetailCard({
    super.key,
    required this.title,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0.r),
      ),
      shadowColor: theme.primaryColorLight,
      color: theme.scaffoldBackgroundColor,
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.primaryColorLight,
              ),
            ),
            SizedBox(height: 8.h),
            Column(children: details),
          ],
        ),
      ),
    );
  }
}
