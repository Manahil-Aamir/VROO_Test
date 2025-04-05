import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/color/color_theme.dart';
import '../../../domain/entity/approved_rides.dart';

class ApprovedRideCard extends StatelessWidget {
  final ApprovedRidesEntity ride;

  const ApprovedRideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme; // Get the text theme

    return Card(
      margin: EdgeInsets.all(12.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      color: ThemeColors.primaryColorDark,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row with Driver Info and Date/Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDriverInfo(textTheme, ride),
                _buildDateTime(textTheme, ride, context),
              ],
            ),
            SizedBox(height: 12.h),

            // Centered Route Information with aligned locations
            _buildRouteInfo(textTheme, ride),
            SizedBox(height: 10.h),

            // Buttons aligned to bottom right
          ],
        ),
      ),
    );
  }

  Widget _buildDriverInfo(TextTheme textTheme, ApprovedRidesEntity ride) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 28.r,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Icon(Icons.person, color: Colors.white, size: 32.r),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ride.riderId,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                // fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Icon(Icons.star, color: ThemeColors.primaryColor, size: 18.r),
                SizedBox(width: 6.w),
                Text(
                  '4.3',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteInfo(TextTheme textTheme, ApprovedRidesEntity ride) {
    return Center(
      child: SizedBox(
        width: 0.8.sw,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: -math.pi / 2,
              child: Icon(
                Icons.u_turn_left_rounded,
                color: ThemeColors.buttonTextColor,
                size: 60.r,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationText(ride.source, textTheme),
                  SizedBox(height: 4.h),
                  _buildLocationText(ride.destination, textTheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationText(String text, TextTheme textTheme) {
    return Text(
      text,
      style: textTheme.bodyMedium?.copyWith(
        color: ThemeColors.buttonTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDateTime(TextTheme textTheme, ApprovedRidesEntity ride, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          DateFormat('dd/MM/yyyy').format(ride.date),
          style: textTheme.bodySmall?.copyWith(
            color: ThemeColors.buttonTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(Icons.access_time, color: ThemeColors.primaryColor, size: 16.r),
            SizedBox(width: 6.w),
            Text(
              DateFormat('h:mm a').format(ride.pickupTimeRange.min),
              style: textTheme.bodySmall?.copyWith(
                color: ThemeColors.buttonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
