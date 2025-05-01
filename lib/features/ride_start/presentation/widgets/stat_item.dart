import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 24.sp, color: theme.primaryColor),
        SizedBox(height: 4.h),
        Text(value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.canvasColor,
            )),
        SizedBox(height: 2.h),
        Text(label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.primaryColorLight,
            )),
      ],
    );
  }
}
