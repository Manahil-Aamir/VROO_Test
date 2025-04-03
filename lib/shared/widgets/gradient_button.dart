import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/core/theme/color/color_theme.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Widget? icon;
  final double gapBetweenIconAndText;

  const GradientButton({
    super.key,
    required this.onTap,
    required this.text,
    this.icon,
    this.gapBetweenIconAndText = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColor,
              theme.primaryColor.withOpacity(0.5),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon!,
              if (icon != null) SizedBox(width: gapBetweenIconAndText.w),
              Text(
                text,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: ThemeColors.primaryColorDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
