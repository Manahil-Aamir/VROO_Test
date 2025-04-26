import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/color/color_theme.dart';
import '../../domain/entity/ride_request_join.dart';
import '../../../../../shared/widgets/custom_dialog.dart';

class PendingJoinCard extends StatelessWidget {
  final RideRequestJoinEntity joinRequest;
  final Function()? onCancelTap;

  const PendingJoinCard({
    Key? key, 
    required this.joinRequest,
    this.onCancelTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      color: ThemeColors.primaryColorDark,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateTimeRow(textTheme),
            Divider(
              color: ThemeColors.buttonTextColor.withOpacity(0.15),
              height: 16.h,
              thickness: 0.5,
            ),
            _buildRouteInfo(textTheme),
            SizedBox(height: 10.h),
            _buildFareAndSeats(textTheme),
            SizedBox(height: 14.h),
            _buildCancelButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeRow(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Date
        Row(
          children: [
            Icon(Icons.calendar_today, size: 14.r, color: ThemeColors.primaryColor),
            SizedBox(width: 6.w),
            Text(
              DateFormat('dd MMM yyyy').format(joinRequest.ride.date),
              style: textTheme.bodySmall?.copyWith(
                color: ThemeColors.buttonTextColor,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        
        // Time
        Row(
          children: [
            Icon(Icons.access_time_rounded, size: 16.r, color: ThemeColors.primaryColor),
            SizedBox(width: 4.w),
            Text(
              "ETA: ${DateFormat('h:mm a').format(joinRequest.riderDetails.eta)}",
              style: textTheme.bodyMedium?.copyWith(
                color: ThemeColors.buttonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteInfo(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(Icons.circle_outlined, color: ThemeColors.primaryColor, size: 16.r),
            Container(
              height: 8.h,
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
                joinRequest.ride.source.address,
                style: textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.buttonTextColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6.h),
              Text(
                joinRequest.ride.destination.address,
                style: textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.buttonTextColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFareAndSeats(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Seats info
        Row(
          children: [
            Icon(Icons.event_seat, size: 18.r, color: ThemeColors.primaryColor),
            SizedBox(width: 4.w),
            Text(
              "${joinRequest.ride.noOfOccupiedSeats}/${joinRequest.ride.noOfSeats} Seats",
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: ThemeColors.buttonTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        
        // Fare
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: ThemeColors.primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            "Rs. ${joinRequest.riderDetails.fare.toStringAsFixed(0)}",
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 15.sp,
              color: ThemeColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      height: 34.h,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showCancelConfirmation(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 0),
        ),
        icon: Icon(
          Icons.close_rounded,
          size: 18.r,
          color: Colors.white,
        ),
        label: Text(
          'Cancel Request',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Cancel Request",
        message: "Are you sure you want to cancel this ride request?",
        confirmText: "Yes, Cancel",
        cancelText: "No",
        confirmColor: ThemeColors.primaryColor,
        cancelColor: ThemeColors.accentColor,
        onConfirm: () {
          Navigator.of(context).pop();
          if (onCancelTap != null) {
            onCancelTap!();
          }
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}
