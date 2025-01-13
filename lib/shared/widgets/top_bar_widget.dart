import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../core/theme/font/font_theme.dart'; // Ensure this is imported

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 20.w,
      right: 20.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.primaryColorDark,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              icon:
                  Icon(Icons.menu, color: ThemeColors.scaffoldBackgroundColor),
              onPressed: () {
                // Handle menu action
              },
            ),
          ),
          Container(
            width: 150.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: ThemeColors.primaryColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                'Driver',
                style: AppFonts.headlineTextStyle.copyWith(
                    color: ThemeColors.scaffoldBackgroundColor,
                    fontStyle: FontStyle.italic,
                    fontSize: AppFonts.headline2TextSize,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.primaryColorDark,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                // Handle notification action
              },
            ),
          ),
        ],
      ),
    );
  }
}
