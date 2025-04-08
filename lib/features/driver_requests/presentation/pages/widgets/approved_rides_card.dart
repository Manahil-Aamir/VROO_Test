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
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      color: ThemeColors.primaryColorDark,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with user info and date/time
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(Icons.person, color: Colors.white, size: 22.r),
                ),
                SizedBox(width: 12.w),
                
                // Name and rating - with more width
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name with proper width
                      Text(
                        ride.riderId, // Will be replaced with name later
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 4.h),
                      // Rating
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: ThemeColors.primaryColor, size: 14.r),
                          SizedBox(width: 4.w),
                          Text(
                            '4.3',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                // Date and time info aligned right
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy').format(ride.date),
                      style: textTheme.bodySmall?.copyWith(
                        color: ThemeColors.buttonTextColor,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time_rounded, color: ThemeColors.primaryColor, size: 14.r),
                        SizedBox(width: 4.w),
                        Text(
                          DateFormat('h:mm a').format(ride.pickupTimeRange.min),
                          style: textTheme.bodySmall?.copyWith(
                            color: ThemeColors.buttonTextColor,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Route information row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Location icons
                Column(
                  children: [
                    Icon(
                      Icons.circle_outlined,
                      color: ThemeColors.primaryColor,
                      size: 16.r,
                    ),
                    Container(
                      height: 12.h,
                      width: 1.w,
                      color: ThemeColors.primaryColor.withOpacity(0.6),
                    ),
                    Icon(
                      Icons.location_on,
                      color: ThemeColors.primaryColor,
                      size: 16.r,
                    ),
                  ],
                ),
                SizedBox(width: 12.w),
                
                // Locations
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source location in single line
                      Text(
                        ride.source,
                        style: textTheme.bodyMedium?.copyWith(
                          color: ThemeColors.buttonTextColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      
                      // Destination in single line
                      Text(
                        ride.destination,
                        style: textTheme.bodyMedium?.copyWith(
                          color: ThemeColors.buttonTextColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 18.w),
                // Price
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: ThemeColors.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Rs. ${ride.fare}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: ThemeColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
