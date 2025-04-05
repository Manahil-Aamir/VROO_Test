import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color/color_theme.dart';

class StatCards extends StatelessWidget {
  final dynamic user;

  const StatCards({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Driver Rating',
                '${user.ratingsAsDriver}',
                Icons.star,
                Colors.yellow,
                theme,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildStatCard(
                'Rider Rating',
                '${user.ratingsAsRider}',
                Icons.person,
                ThemeColors.primaryColor,
                theme,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'As Driver',
                '${user.totalRidesAsDriver}',
                Icons.drive_eta,
                ThemeColors.accentColor,
                theme,
                subtitle: 'Total Rides',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildStatCard(
                'As Rider',
                '${user.totalRidesAsRider}',
                Icons.emoji_people,
                ThemeColors.primaryColorDark,
                theme,
                subtitle: 'Total Rides',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme, {
    String? subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeColors.backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.primaryColor.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28.w),
          SizedBox(height: 12.h),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: ThemeColors.bodyTextColor,
            ),
          ),
          if (subtitle != null) ...[
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                color: ThemeColors.captionTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
