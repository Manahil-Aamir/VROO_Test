import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverAndFare extends StatelessWidget {
  final String driverName;
  final double rating;
  final int trips;
  final int fare;

  const DriverAndFare({
    super.key,
    required this.driverName,
    required this.rating,
    required this.trips,
    required this.fare,
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
              radius: 24.r,
              backgroundColor: theme.scaffoldBackgroundColor,
              child: CircleAvatar(
                radius: 22.r,
                backgroundColor: theme.primaryColorDark,
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
                  driverName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.scaffoldBackgroundColor,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star_rounded,
                        color: theme.primaryColor, size: 14.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '$rating • $trips Trips',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Text(
          'Rs $fare',
          style: theme.textTheme.displayMedium?.copyWith(
              color: theme.primaryColor,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
