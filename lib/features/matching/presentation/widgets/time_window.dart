import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vroo_test/features/matching/presentation/widgets/time_change.dart';

import '../bloc/bloc/matching_bloc.dart';
import '../bloc/event/matching_event.dart';

class TimeWindowWidget extends StatefulWidget {
  final TimeOfDay minPickupTime;
  final TimeOfDay maxPickupTime;
  final String rideRequestId;
  final DateTime scheduleDate;

  const TimeWindowWidget({
    super.key,
    required this.minPickupTime,
    required this.maxPickupTime,
    required this.rideRequestId,
    required this.scheduleDate,
  });

  @override
  _TimeWindowWidgetState createState() => _TimeWindowWidgetState();
}

class _TimeWindowWidgetState extends State<TimeWindowWidget> {
  late TimeOfDay minPickupTime;
  late TimeOfDay maxPickupTime;

  @override
  void initState() {
    super.initState();
    minPickupTime = widget.minPickupTime;
    maxPickupTime = widget.maxPickupTime;
  }

  void _modifyPickupTime(String timeType, int adjustment) {
    setState(() {
      if (timeType == "startTime" || timeType == "min") {
        final totalMinutes =
            minPickupTime.hour * 60 + minPickupTime.minute + adjustment;
        minPickupTime = TimeOfDay(
          hour: (totalMinutes ~/ 60) % 24,
          minute: totalMinutes % 60,
        );

        if (_calculateMinutes(minPickupTime) >
            _calculateMinutes(maxPickupTime)) {
          maxPickupTime = minPickupTime;
        }
      } else if (timeType == "endTime" || timeType == "max") {
        final totalMinutes =
            maxPickupTime.hour * 60 + maxPickupTime.minute + adjustment;
        maxPickupTime = TimeOfDay(
          hour: (totalMinutes ~/ 60) % 24,
          minute: totalMinutes % 60,
        );

        if (_calculateMinutes(minPickupTime) >
            _calculateMinutes(maxPickupTime)) {
          minPickupTime = maxPickupTime;
        }
      }
    });

    final modifyData = {
      "pickupTimeRange": {
        "min": formatISO8601DateTime(widget.scheduleDate, minPickupTime),
        "max": formatISO8601DateTime(widget.scheduleDate, maxPickupTime),
      },
    };

    context.read<MatchingBloc>().add(
          ModifyTimeWindowEvent(
              id: widget.rideRequestId, modifyData: modifyData),
        );

    print("Updated Time Window: $modifyData");
  }

  int _calculateMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  String formatISO8601DateTime(DateTime date, TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return "${DateFormat("yyyy-MM-dd").format(date)}T$hours:$minutes:00";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Card-based UI for better structure
        SizedBox(
          width: 400.w, // Assigning width to the Card
          child: Card(
            color: theme.primaryColorDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 4.h,
            child: TimeAdjustmentWidget(
              startTime: minPickupTime,
              endTime: maxPickupTime,
              onTimeChanged: _modifyPickupTime,
            ),
          ),
        ),
      ],
    );
  }
}
