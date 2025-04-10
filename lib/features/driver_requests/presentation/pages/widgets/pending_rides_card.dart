import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/color/color_theme.dart';
import '../../../domain/entity/pending_rides.dart';
import '../../bloc/bloc/pending_rides_bloc.dart';
import '../../bloc/event/pending_rides_event.dart';

class PendingRideCard extends StatelessWidget {
  final PendingRidesEntity ride;

  const PendingRideCard({super.key, required this.ride});

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
            // Top row: Avatar, name, rating, date/time
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(Icons.person, color: Colors.white, size: 22.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.riderDetails.name,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: ThemeColors.primaryColor, size: 14.r),
                          SizedBox(width: 4.w),
                          Text(
                            ride.riderDetails.ratings.asRider.toString(),
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
                SizedBox(width: 18.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('dd/MMM/yyyy').format(ride.date),
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
                          DateFormat('h:mm a').format(ride.eta),
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
            // Route section
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(Icons.circle_outlined, color: ThemeColors.primaryColor, size: 16.r),
                    Container(
                      height: 12.h,
                      width: 1.w,
                      color: ThemeColors.primaryColor.withOpacity(0.6),
                    ),
                    Icon(Icons.location_on, color: ThemeColors.primaryColor, size: 16.r),
                  ],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.source.address,
                        style: textTheme.bodyMedium?.copyWith(
                          color: ThemeColors.buttonTextColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        ride.destination.address,
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
                Row(
                  children: [
                    _buildIconButton(Icons.close, () {
                      final request = ride.request;
                      context.read<PendingRidesBloc>().add(
                        RejectRideRequestEvent(
                          rideRequestId: request.id,
                          rideId: request.rideId,
                        ),
                      );
                    }),
                    SizedBox(width: 12.w),
                    _buildIconButton(Icons.check, () {
                      final request = ride.request;
                      context.read<PendingRidesBloc>().add(
                        ApproveRideRequestEvent(
                          rideRequestId: request.id,
                          rideId: request.rideId,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.orange, width: 2),
        ),
        child: Icon(icon, color: Colors.orange, size: 18.r),
      ),
    );
  }
}
