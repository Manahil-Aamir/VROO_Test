import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeAdjustmentWidget extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final String timeType;
  final Function(String, int) onTimeChanged;

  const TimeAdjustmentWidget({
    super.key,
    required this.label,
    required this.time,
    required this.timeType,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColorDark,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decrease button
            ElevatedButton(
              onPressed: () => onTimeChanged(timeType, -5),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(
                  side: BorderSide(color: theme.primaryColorDark, width: 1.5.w),
                ),
                padding: EdgeInsets.all(8),
              ),
              child: Icon(
                Icons.remove,
                size: 24.sp,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(width: 10.w),
            // Time Display
            Container(
              width: 100,
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border.all(color: theme.primaryColor, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  time.format(context),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.primaryColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            // Increase button
            ElevatedButton(
              onPressed: () => onTimeChanged(timeType, 5),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(
                  side: BorderSide(color: theme.primaryColorDark, width: 1.5.w),
                ),
                padding: EdgeInsets.all(8),
                backgroundColor: theme.scaffoldBackgroundColor,
              ),
              child: Icon(
                Icons.add,
                size: 24.sp,
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
