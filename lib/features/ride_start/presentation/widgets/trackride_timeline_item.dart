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
  final String passengerId;
  final String? status;
  final RidestartDataModel rideData;
  final Function(String passengerId, String action)? onConfirm;

  const TrackRideTimelineItem({
    super.key,
    required this.time,
    required this.title,
    required this.address,
    this.status,
    this.fare,
    this.isSource = false,
    this.isDestination = false,
    required this.isPassenger,
    this.isConfirmed = false,
    required this.passengerId,
    required this.rideData,
    this.onConfirm,
  });

  String _getActionType() {
    if (isSource) {
      return 'drop'; // At passenger's source location, action is to pick up
    } else if (isDestination) {
      return 'pick'; // At passenger's destination location, action is to drop off
    }
    return 'pick'; // Default to pick for other cases
  }

  String _getConfirmButtonText() {
    if (isSource && isPassenger) {
      return 'Drop-Off';
    } else if (isDestination && isPassenger) {
      return 'Pick Up';
    } else if (isConfirmed) {
      return 'Confirmed'; // Show as confirmed if already done
    }
    return 'Pick Up';
  }

  String _getDialogTitle() {
    if (isSource) {
      return 'Confirm Drop Off';
    } else if (isDestination) {
      return 'Confirm Pick Up';
    }
    return 'Confirm Pickup';
  }

  String _getDialogMessage() {
    if (isSource) {
      return 'Do you want to confirm drop off for this passenger?';
    } else if (isDestination) {
      return 'Do you want to confirm pick up for this passenger?';
    }
    return 'Do you want to confirm pickup for this passenger?';
  }

  bool _shouldShowButton() {
    print(
        'Status: $status, isPassenger: $isPassenger, isConfirmed: $isConfirmed');
    // Don't show button if status is 'Picked' or 'Dropped'
    if (status != null &&
        (status!.toLowerCase() == 'picked' ||
            status!.toLowerCase() == 'dropped')) {
      return false;
    }
    return isPassenger && !isConfirmed;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                            // Show pick/drop buttons ONLY for passengers (not source/destination locations)
                            if (_shouldShowButton())
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: StartButton(
                                  onTap: () {
                                    final action = _getActionType();
                                    showDialog(
                                      context: context,
                                      builder: (context) => CustomDialog(
                                        title: _getDialogTitle(),
                                        message: _getDialogMessage(),
                                        confirmText: 'Confirm',
                                        cancelText: 'Cancel',
                                        confirmColor: theme.primaryColor,
                                        cancelColor: theme.primaryColorDark,
                                        onConfirm: () {
                                          Navigator.of(context).pop();
                                          if (onConfirm != null) {
                                            final action = _getActionType();
                                            onConfirm!(passengerId, action);
                                          }
                                        },
                                        onCancel: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    );
                                  },
                                  text: _getConfirmButtonText(),
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
                              color: theme.primaryColorLight,
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
