import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/ride_start/presentation/widgets/timeline_item.dart';

class RideTimeline extends StatelessWidget {
  final List<TimelineItem> items;

  const RideTimeline({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        // Continuous vertical line
        Positioned(
          left: 86.w, // Centered in timeline column
          top: 18.h, // Start from the center of first icon
          bottom: 90.h, // End at the center of last icon
          width: 4.w,
          child: Container(color: theme.primaryColorLight),
        ),

        // List of timeline items
        Column(
          children: items
              .map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Stack(
                      children: [
                        // Timeline item
                        item,

                        // Icon on top of the line
                        Positioned(
                          left: 70.w,
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
                                      : Icons.person,
                              color: theme.primaryColor,
                              size: 18.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
