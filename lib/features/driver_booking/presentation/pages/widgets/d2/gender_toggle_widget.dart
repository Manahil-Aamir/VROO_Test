import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/color/color_theme.dart';
import '../../../../../../core/theme/font/font_theme.dart';

class GenderToggleWidget extends StatelessWidget {
  final bool sameGenderOnly;
  final ValueChanged<bool> onGenderToggled;

  const GenderToggleWidget({Key? key, required this.sameGenderOnly, required this.onGenderToggled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeColors.backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.w)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Icon(Icons.people_alt, color: ThemeColors.primaryColor, size: 24.w),
              SizedBox(width: 12.w),
              Text('Same Gender Only', style: AppFonts.bodyTextStyle.copyWith(fontSize: AppFonts.body1TextSize, color: ThemeColors.headlinesTextColor, fontWeight: FontWeight.w500)),
            ]),
            Switch.adaptive(value: sameGenderOnly, onChanged: onGenderToggled, activeColor: Colors.white, activeTrackColor: ThemeColors.primaryColor),
          ],
        ),
      ),
    );
  }
}