import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeAdjustmentWidget extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Function(String, int) onTimeChanged;

  const TimeAdjustmentWidget({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Heading for the entire section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 20.sp,
                color: theme.scaffoldBackgroundColor,
              ),
              SizedBox(width: 8.w),
              Text('Pickup Between',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.scaffoldBackgroundColor,
                  )),
            ],
          ),
          SizedBox(height: 8.h),
          // Time range row with two adjustment widgets and an arrow in between
          Row(
            children: [
              // Start time widget
              Expanded(
                child: _buildTimeAdjustment(
                  context,
                  startTime,
                  'startTime',
                  theme,
                ),
              ),

              SizedBox(width: 8.w),

              // Arrow icon
              Icon(
                Icons.arrow_forward_rounded,
                size: 24.sp,
                color: theme.scaffoldBackgroundColor,
              ),

              SizedBox(width: 8.w),

              // End time widget
              Expanded(
                child: _buildTimeAdjustment(
                  context,
                  endTime,
                  'endTime',
                  theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeAdjustment(
      BuildContext context, TimeOfDay time, String timeType, ThemeData theme) {
    return Row(
      children: [
        // Decrease button
        _buildButton(
          Icons.remove,
          () => onTimeChanged(timeType, -5),
          theme,
        ),

        SizedBox(width: 8.w),

        // Time display
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              color: theme.scaffoldBackgroundColor,
              child: Center(
                child: Text(_formatTime(time),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.primaryColorDark,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
          ),
        ),

        SizedBox(width: 8.w),

        // Increase button
        _buildButton(
          Icons.add,
          () => onTimeChanged(timeType, 5),
          theme,
        ),
      ],
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onPressed, ThemeData theme) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(
          35.r), // Make border radius large for a circular shape
      child: Container(
        padding: EdgeInsets.all(
            4.r), // Adjust padding for better circular appearance
        decoration: BoxDecoration(
          color: theme.primaryColor, // Move color inside BoxDecoration
          shape: BoxShape.circle, // Use BoxShape.circle for circular background
        ),
        child: Icon(
          icon,
          color: theme.scaffoldBackgroundColor,
          size: 18.sp,
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
