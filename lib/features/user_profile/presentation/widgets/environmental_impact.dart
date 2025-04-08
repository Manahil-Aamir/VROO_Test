import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color/color_theme.dart';

class EnvironmentalImpact extends StatelessWidget {
  final dynamic user;
  
  const EnvironmentalImpact({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeColors.backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.primaryColor.withOpacity(0.075),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildImpactStats(theme),
          SizedBox(height: 16.h),
          _buildEcoMessage(theme),
        ],
      ),
    );
  }

  Widget _buildImpactStats(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Icon(
                Icons.eco,
                color: ThemeColors.secondaryColor,
                size: 36.w,
              ),
              SizedBox(height: 8.h),
              Text(
                '${user.co2Saved} kg',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.secondaryColor,
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
        ),
        Container(
          height: 60.h,
          width: 1.w,
          color: ThemeColors.dividerColor,
        ),
        Expanded(
          child: Column(
            children: [
              Icon(
                Icons.local_gas_station,
                color: ThemeColors.primaryColor,
                size: 36.w,
              ),
              SizedBox(height: 8.h),
              Text(
                '${user.fuelSaved} L',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.primaryColor,
                ),
              ),
              Text(
                'Fuel Saved',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ThemeColors.appBarIconsColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEcoMessage(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ThemeColors.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insights, 
            color: ThemeColors.secondaryColor, 
            size: 24.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'You\'ve reduced your carbon footprint by carpooling!',
              style: theme.textTheme.bodySmall?.copyWith(
                color: ThemeColors.secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
