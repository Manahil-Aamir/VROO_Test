import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverAndFare extends StatelessWidget {
  final String driverName;
  final double rating;
  final int trips;
  final double fare;
  final String estimatedArrivalTime;

  const DriverAndFare({
    super.key,
    required this.driverName,
    required this.rating,
    required this.trips,
    required this.fare,
    required this.estimatedArrivalTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: theme.scaffoldBackgroundColor,
              child: CircleAvatar(
                radius: 22.r,
                backgroundColor: theme.primaryColorDark.withOpacity(0.8),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: theme.primaryColor,
                  size: 24.sp,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverName.length > 20
                      ? '${driverName.substring(0, 17)}...'
                      : driverName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.scaffoldBackgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.star_rounded,
                        color: theme.primaryColor, size: 14.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '$rating • $trips Trips',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.scaffoldBackgroundColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Rs $fare',
              style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.primaryColor,
                  fontSize: 21.sp,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'ETA: $estimatedArrivalTime', // example: 2:53 PM
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.scaffoldBackgroundColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
