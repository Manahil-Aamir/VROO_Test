import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/color/color_theme.dart';
import '../../../../../../core/theme/font/font_theme.dart';

class SeatsControlWidget extends StatelessWidget {
  final int availableSeats;
  final ValueChanged<int> onSeatsChanged;

  const SeatsControlWidget(
      {super.key, required this.availableSeats, required this.onSeatsChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeColors.backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.w)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.event_seat,
                  color: ThemeColors.primaryColor, size: 24.w),
              SizedBox(width: 8.w),
              Text('Available Seats',
                  style: AppFonts.bodyTextStyle.copyWith(
                      fontSize: AppFonts.body1TextSize,
                      color: ThemeColors.headlinesTextColor,
                      fontWeight: FontWeight.w500)),
            ]),
            SizedBox(height: 16.h),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      ThemeColors.primaryColor.withOpacity(0.8),
                      ThemeColors.primaryColor.withOpacity(0.8)
                    ]),
                    borderRadius: BorderRadius.circular(12.w)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(Icons.remove, color: Colors.white),
                        onPressed: () => onSeatsChanged(availableSeats - 1)),
                    Container(
                        width: 80.w,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.w)),
                        child: Center(
                            child: Text('$availableSeats',
                                style: AppFonts.headlineTextStyle.copyWith(
                                    fontSize: AppFonts.headline3TextSize,
                                    color: ThemeColors.primaryColorDark,
                                    fontWeight: FontWeight.bold)))),
                    IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () => onSeatsChanged(availableSeats + 1)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
