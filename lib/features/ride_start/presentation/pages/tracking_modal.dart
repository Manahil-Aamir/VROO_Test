import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vroo_test/features/ride_start/data/models/ridestart_data_model.dart';
import 'package:vroo_test/features/ride_start/presentation/widgets/trackride_timeline.dart';
import 'package:vroo_test/features/ride_start/presentation/widgets/trackride_timeline_item.dart';
import '../widgets/stat_item.dart';

class TrackingRideDetailsBottomSheet extends StatefulWidget {
  final RidestartDataModel rideData;
  const TrackingRideDetailsBottomSheet({
    super.key,
    required this.rideData,
  });

  @override
  State<TrackingRideDetailsBottomSheet> createState() =>
      _TrackingRideDetailsBottomSheetState();
}

class _TrackingRideDetailsBottomSheetState
    extends State<TrackingRideDetailsBottomSheet> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print("Is expanded: $_isExpanded");
    final modalHeight =
        _isExpanded ? MediaQuery.of(context).size.height * 0.70 : 250.h;
    print(_isExpanded);
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: 0,
      right: 0,
      bottom: 0,
      height: modalHeight,
      child: GestureDetector(
        onTap: () {
          if (_isExpanded) {
            _minimizeModal();
          } else {
            _expandModal();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: theme.primaryColorDark,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: _buildModalContent(context),
        ),
      ),
    );
  }

  void _expandModal() {
    setState(() {
      _isExpanded = true;
      print('Maximizing modal');
    });
  }

  void _minimizeModal() {
    setState(() {
      _isExpanded = false;
    });
  }

  Widget _buildModalContent(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),

          // Ride Summary
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ride Details',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.canvasColor,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Ride Stats
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatItem(
                  icon: Icons.person,
                  value:
                      '${widget.rideData.passengers.length}/${widget.rideData.numOfSeats.toInt() + widget.rideData.passengers.length}',
                  label: 'Passengers',
                ),
                StatItem(
                  icon: Icons.access_time,
                  value: '${(widget.rideData.duration / 60).toInt()} min',
                  label: 'Duration',
                ),
                StatItem(
                  icon: Icons.straighten,
                  value: '${(widget.rideData.distance / 1000).toInt()} km',
                  label: 'Distance',
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Ride Timeline
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TrackingRideTimeline(
              items: [
                TrackRideTimelineItem(
                  passengerId: widget.rideData.driverId,
                  time: DateFormat('h:mm a')
                      .format(widget.rideData.departureTime),
                  title: 'Source',
                  address: widget.rideData.source.address,
                  isSource: true,
                  isPassenger: false,
                  isDestination: false,
                  rideData: widget.rideData,
                ),
                ...widget.rideData.passengers.map((passenger) {
                  final p = passenger;
                  final isSameSource = p.sameSource;
                  print('${p.sameDestination} ${p.sameSource}');
                  print(isSameSource);

                  return TrackRideTimelineItem(
                    passengerId: p.riderId,
                    time: DateFormat('h:mm a')
                        .format(p.rideRequest.matches.first.eta),
                    title: (isSameSource ?? false)
                        ? 'Drop Off ${p.riderName}'
                        : 'Pickup ${p.riderName}',
                    address: (isSameSource ?? false)
                        ? p.rideRequest.destination.address
                        : p.rideRequest.source.address,
                    fare: p.fare,
                    isSource: isSameSource ?? false,
                    isDestination: !(isSameSource ?? false),
                    isPassenger: true,
                    rideData: widget.rideData,
                  );
                }),
                TrackRideTimelineItem(
                  passengerId: widget.rideData.driverId,
                  time: DateFormat('h:mm a')
                      .format(widget.rideData.expectedArrivalTime),
                  title: 'Final Destination',
                  address: widget.rideData.destination.address,
                  isSource: false,
                  isDestination: true,
                  isPassenger: false,
                  rideData: widget.rideData,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
