import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../data/models/rider_view_model.dart';

class RideDetailsBottomSheet extends StatefulWidget {
  final RideViewModel rideData;
  const RideDetailsBottomSheet({
    super.key,
    required this.rideData,
  });

  @override
  State<RideDetailsBottomSheet> createState() => _RideDetailsBottomSheetState();
}

class _RideDetailsBottomSheetState extends State<RideDetailsBottomSheet> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final modalHeight =
        _isExpanded ? MediaQuery.of(context).size.height * 0.6 : 320.h;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: 0,
      right: 0,
      bottom: 0,
      height: modalHeight,
      child: GestureDetector(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
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

  Widget _buildModalContent(BuildContext context) {
    final theme = Theme.of(context);
    final expectedArrival =
        _formatDateTime(widget.rideData.expectedArrivalTime);

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

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ride Details',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.canvasColor,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Driver Info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildDriverInfo(),
          ),

          ...[
            Divider(height: 24.h, thickness: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildRideInfo(),
            ),
          ],

          if (widget.rideData.otherPassengers != null &&
              widget.rideData.otherPassengers!.isNotEmpty) ...[
            Divider(height: 24.h, thickness: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildOtherPassengersInfo(),
              ),
            ),
          ],

          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildDriverInfo() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First row: Person icon, driver name, and ETA
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 24.r,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              widget.rideData.driverName,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.canvasColor,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: theme.primaryColorLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16.r,
                    color: theme.canvasColor,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'ETA: ${_formatDateTime(widget.rideData.expectedArrivalTime)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.canvasColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        // Second row: Car icon and details
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car,
                size: 24.r,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${widget.rideData.carDetails.company} ${widget.rideData.carDetails.model} • ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.canvasColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: widget.rideData.carDetails.numberPlate,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.canvasColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRideInfo() {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Connecting line
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                // SizedBox(height: 8.h),
                Icon(
                  Icons.circle_outlined, // Ring icon
                  color: theme.primaryColor,
                  size: 14.sp,
                ),
                Container(
                  width: 2, // Thin vertical line
                  height: 10.h, // Adjust for spacing between icons
                  color: theme.primaryColor,
                ),
                Icon(
                  Icons.location_on, // Location icon
                  color: theme.primaryColor,
                  size: 14.sp,
                ),
                SizedBox(height: 8.h),
              ],
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.rideData.passengerData.source.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.scaffoldBackgroundColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    widget.rideData.passengerData.destination.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.scaffoldBackgroundColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),

        Row(
          children: [
            Expanded(
              child: _buildInfoBox(
                title: 'DetourDistance',
                value:
                    '${(widget.rideData.passengerData.detourDistance).toStringAsFixed(1)} m',
                icon: Icons.route,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildInfoBox(
                title: 'Duration',
                value: _formatDuration(widget.rideData.duration),
                icon: Icons.access_time,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoBox({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: theme.primaryColorLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.r,
            color: theme.primaryColor,
          ),
          SizedBox(width: 4.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.canvasColor,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.canvasColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOtherPassengersInfo() {
    final theme = Theme.of(context);
    if (widget.rideData.otherPassengers == null ||
        widget.rideData.otherPassengers!.isEmpty) {
      return [];
    }

    return [
      Text(
        'Passengers',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.canvasColor,
        ),
      ),
      SizedBox(height: 8.h),
      ...widget.rideData.otherPassengers!.map((passenger) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Container(
            width: 200.w,
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: theme.primaryColorLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  radius: 16.r,
                  child: Icon(
                    Icons.person,
                    size: 16.sp,
                    color: theme.primaryColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  passenger.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.canvasColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ];
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = (minutes / 60).floor();
      final remainingMinutes = minutes % 60;
      return '$hours h ${remainingMinutes > 0 ? '$remainingMinutes min' : ''}';
    }
  }
}
