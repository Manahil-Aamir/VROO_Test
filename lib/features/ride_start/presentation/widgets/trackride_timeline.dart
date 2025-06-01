import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/ride_start/presentation/bloc/event/ridestart_event.dart';

import 'package:vroo_test/features/ride_start/presentation/widgets/trackride_timeline_item.dart';

import '../bloc/bloc/ridestart_bloc.dart';

class TrackingRideTimeline extends StatefulWidget {
  final List<dynamic> items; // Assuming items have the required properties

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
    confirmedStatus = List.generate(widget.items.length,
        (index) => widget.items[index].isConfirmed ?? false);
  }

  void _handleConfirmation(String passengerId, String action, int index) {
    // Dispatch BLoC event to update passenger
    context.read<RideStartBloc>().add(UpdatePassengerEvent(
          passengerId,
          action,
        ));

    // Update local state for immediate UI feedback
    setState(() {
      confirmedStatus[index] = true;
    });

    print('Confirmed $action for passenger $passengerId');

    // Force rebuild after confirmation
    setState(() {});
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
                    // Timeline item with onConfirm callback
                    TrackRideTimelineItem(
                      status: item.status ?? '',

                      time: item.time ?? '',
                      title: item.title ?? '',
                      address: item.address ?? '',
                      fare: item.fare,
                      isSource: item.isSource ?? false,
                      isDestination: item.isDestination ?? false,
                      isPassenger: isPassenger,
                      isConfirmed: confirmedStatus[index],
                      passengerId:
                          item.passengerId ?? 'passenger_$index', // Fallback ID
                      rideData: item.rideData,
                      onConfirm: !confirmedStatus[index]
                          ? (passengerId, action) =>
                              _handleConfirmation(passengerId, action, index)
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
                          isPassenger
                              ? ((item.status == 'Dropped' ||
                                      item.status == 'Picked')
                                  ? Icons
                                      .check_circle // Tick if Dropped or Picked
                                  : Icons
                                      .account_circle) // Account for passenger
                              : (item.isSource ?? false)
                                  ? Icons.location_on // Check on source
                                  : (item.isDestination ?? false)
                                      ? Icons.flag // Check on destination
                                      : confirmedStatus[index]
                                          ? Icons
                                              .check_circle // Check for others if confirmed
                                          : Icons.account_circle, // Default
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
