import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color/color_theme.dart';

class InitialsCircleAvatar extends StatelessWidget {
  final String initials;
  final double radius; 
  final bool showCameraIcon;
  final double textScaleFactor;

  const InitialsCircleAvatar({
    super.key,
    required this.initials,
    this.radius = 40.0,
    this.showCameraIcon = false,
    this.textScaleFactor = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double scaledRadius = radius.r;
    final double fontSize = scaledRadius * textScaleFactor;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: EdgeInsets.all(2.r),
          decoration: BoxDecoration(
            color: ThemeColors.backgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ThemeColors.headlinesTextColor.withOpacity(0.1),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: scaledRadius,
            backgroundColor: ThemeColors.primaryColor.withOpacity(0.2),
            child: Text(
              initials,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: ThemeColors.primaryColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (showCameraIcon)
          Positioned(
            bottom: 4.r,
            right: 4.r,
            child: CircleAvatar(
              radius: scaledRadius * 0.3,
              backgroundColor: ThemeColors.primaryColor,
              child: Icon(
                Icons.camera_alt,
                size: scaledRadius * 0.25,
                color: ThemeColors.buttonTextColor,
              ),
            ),
          ),
      ],
    );
  }
}
