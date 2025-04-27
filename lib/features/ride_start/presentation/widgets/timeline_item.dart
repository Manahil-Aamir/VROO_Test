import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimelineItem extends StatelessWidget {
  final String time;
  final String title;
  final String address;
  final double? fare;
  final bool isSource;
  final bool isDestination;

  const TimelineItem({
    super.key,
    required this.time,
    required this.title,
    required this.address,
    this.fare,
    this.isSource = false,
    this.isDestination = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    // Determine icon and colors based on type
    IconData iconData;
    Color iconColor = theme.primaryColor;
    Color bgColor = theme.primaryColor.withOpacity(0.2);

    if (isSource) {
      iconData = Icons.location_on;
    } else if (isDestination) {
      iconData = Icons.flag;
    } else {
      iconData = Icons.person;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main content row
        Padding(
          padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time column
              SizedBox(
                width: 40.w,
                child: Text(
                  time,
                  style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600, color: theme.primaryColor),
                ),
              ),

              // Space for timeline (actual line is in the stack background)
              SizedBox(width: 30.w),

              // Content column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.canvasColor,
                              fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        if (fare != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Rs. ${fare!.toInt()}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
