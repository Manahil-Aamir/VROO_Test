import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vroo_test/features/ride_start/presentation/widgets/trackride_timeline_item.dart';

class TrackingRideTimeline extends StatefulWidget {
  final List<TrackRideTimelineItem> items;

  const TrackingRideTimeline({super.key, required this.items});

  @override
  State<TrackingRideTimeline> createState() => _TrackingRideTimelineState();
}

class _TrackingRideTimelineState extends State<TrackingRideTimeline> {
  // Track confirmation status for each passenger
  late List<bool> confirmedStatus;

  @override
  void initState() {
    super.initState();
    // Initialize confirmation status for all items
    confirmedStatus = List.generate(
        widget.items.length, (index) => widget.items[index].isConfirmed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        // Continuous vertical line
        Positioned(
          left: 46.w, // Centered in timeline column
          top: 18.h, // Start from the center of first icon
          bottom: 90.h, // End at the center of last icon
          width: 4.w,
          child: Container(color: theme.primaryColorLight),
        ),

        // List of timeline items
        Column(
          children: List.generate(
            widget.items.length,
            (index) {
              final item = widget.items[index];
              final isPassenger = item.fare != null;

              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Stack(
                  children: [
                    // Timeline item with onConfirm callback if it's a passenger
                    TrackRideTimelineItem(
                      time: item.time,
                      title: item.title,
                      address: item.address,
                      fare: item.fare,
                      isSource: item.isSource,
                      isDestination: item.isDestination,
                      isConfirmed: confirmedStatus[index],
                      rideData: item.rideData,
                      onConfirm: isPassenger && !confirmedStatus[index]
                          ? () {
                              setState(() {
                                confirmedStatus[index] = true;
                              });
                            }
                          : null,
                    ),

                    // Icon on top of the line
                    Positioned(
                      left: 30.w,
                      top: 0,
                      child: Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: theme.canvasColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.isSource
                              ? Icons.location_on
                              : item.isDestination
                                  ? Icons.flag
                                  : confirmedStatus[index]
                                      ? Icons.check_circle
                                      : Icons.account_circle,
                          color: theme.primaryColor,
                          size: 18.r,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
