import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/ride_start/presentation/widgets/start_button.dart';

import '../../../../shared/widgets/custom_dialog.dart';
import '../../data/models/ridestart_data_model.dart';

class TrackRideTimelineItem extends StatelessWidget {
  final String time;
  final String title;
  final String address;
  final double? fare;
  final bool isSource;
  final bool isDestination;
  final bool isPassenger;
  final bool isConfirmed;
  final RidestartDataModel rideData;
  final Function()? onConfirm;

  const TrackRideTimelineItem({
    super.key,
    required this.time,
    required this.title,
    required this.address,
    this.fare,
    this.isSource = false,
    this.isDestination = false,
    this.isPassenger = false,
    this.isConfirmed = false,
    required this.rideData,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    // Determine icon and colors based on type and confirmation status
    IconData iconData;

    if (isSource) {
      iconData = Icons.location_on;
    } else if (isDestination) {
      iconData = Icons.flag;
    } else if (isConfirmed) {
      iconData = Icons.check_circle; // Tick icon when confirmed
    } else {
      iconData = Icons.account_circle; // Different passenger icon
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
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor),
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
                        Row(
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.canvasColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            if (!isSource && !isDestination && !isConfirmed)
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: StartButton(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => CustomDialog(
                                        title: 'Confirm Pickup',
                                        message:
                                            'Do you want to confirm pickup for this passenger?',
                                        confirmText: 'Confirm',
                                        cancelText: 'Cancel',
                                        confirmColor: theme.primaryColor,
                                        cancelColor: theme.primaryColorDark,
                                        onConfirm: () {
                                          Navigator.of(context).pop();
                                          if (onConfirm != null) {
                                            onConfirm!();
                                          }
                                        },
                                        onCancel: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    );
                                  },
                                  text: 'Confirm',
                                ),
                              ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            address,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        if (fare != null)
                          Container(
                            margin: EdgeInsets.only(left: 8.w),
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
