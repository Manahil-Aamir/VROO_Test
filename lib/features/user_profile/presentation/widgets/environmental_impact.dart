import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color/color_theme.dart';

class EnvironmentalImpact extends StatelessWidget {
  final dynamic user;
  const EnvironmentalImpact({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: user.co2Saved == 0
            ? ThemeColors.primaryColor.withOpacity(0.08)
            : ThemeColors.secondaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.eco,
              color: user.co2Saved == 0
                  ? ThemeColors.primaryColor
                  : ThemeColors.secondaryColor,
              size: 28.w,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.co2Saved.toStringAsFixed(3)} kg',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: user.co2Saved == 0
                      ? ThemeColors.primaryColor
                      : ThemeColors.secondaryColor,
                ),
              ),
              Text(
                'CO₂ Saved',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ThemeColors.appBarIconsColor,
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              user.co2Saved == 0
                  ? 'Start carpooling to reduce your carbon footprint!'
                  : 'You\'ve reduced your carbon footprint by carpooling!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: user.co2Saved == 0
                    ? ThemeColors.primaryColor
                    : ThemeColors.secondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
