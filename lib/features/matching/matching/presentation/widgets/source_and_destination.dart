import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class SourceAndDestinationWidget extends StatelessWidget {
  final String source;
  final String destination;

  const SourceAndDestinationWidget({
    super.key,
    required this.source,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            // SizedBox(height: 8.h),
            Icon(
              Icons.circle_outlined, // Ring icon
              color: theme.primaryColor,
              size: 14.sp,
            ),
            Container(
              width: 2, // Thin vertical line
              height: 10.h, // Adjust for spacing between icons
              color: theme.primaryColor,
            ),
            Icon(
              Icons.location_on, // Location icon
              color: theme.primaryColor,
              size: 14.sp,
            ),
            SizedBox(height: 8.h),
          ],
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                source,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                destination,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
