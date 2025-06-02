import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vroo_test/features/ride_start/data/models/ride_start_model.dart';
import '../../../../../core/router/navigation.dart';
import '../../../../../core/theme/color/color_theme.dart';
import '../../../../../shared/widgets/custom_dialog.dart';
import '../../../../../shared/widgets/dialog_button.dart';
import '../../../domain/entity/active_ride.dart';
import '../../bloc/bloc/active_rides_bloc.dart';
import '../../bloc/event/active_rides_event.dart';
import '../../bloc/state/active_rides_state.dart';

class ActiveRideCard extends StatelessWidget {
  final ActiveRideEntity ride;

  const ActiveRideCard({super.key, required this.ride});

  @override
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<ActiveRidesDriverBloc, ActiveRidesDriverState>(
      listener: (context, state) {
        print('state: $state');
        if (state is ActiveRideDataLoaded) {
          print('Ride data loaded: ${state.rideData}');
          // Navigate to ride details page
          Navigator.pushNamed(
            context,
            '/static_page', // Change to your actual route name
            //arguments: state.rideData, // Send the loaded ride data as argument
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          context.read<Navigation>().navigateTo(
                '/ride_request_status',
                arguments: ride.id.toString(),
              );
        },
        child: Card(
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
                _buildDateTimeRow(context, textTheme),
                Divider(
                  color: ThemeColors.buttonTextColor.withOpacity(0.15),
                  height: 16.h,
                  thickness: 0.5,
                ),
                _buildRouteInfo(textTheme),
                SizedBox(height: 6.h),
                _buildCarDetails(textTheme),
                SizedBox(height: 12.h),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeRow(BuildContext context, TextTheme textTheme) {
    final maxArrival = ride.maxArrivalTime;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Date info
        Text(
          DateFormat('dd MMM yyyy').format(ride.date),
          style: textTheme.bodySmall?.copyWith(
            color: ThemeColors.buttonTextColor,
            fontSize: 12.sp,
          ),
        ),

        // Time info
        Row(
          children: [
            Icon(Icons.access_time_rounded,
                color: ThemeColors.primaryColor, size: 16.r),
            SizedBox(width: 4.w),
            Text(
              "${MaterialLocalizations.of(context).formatTimeOfDay(ride.time)} - "
              "${MaterialLocalizations.of(context).formatTimeOfDay(maxArrival)}",
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Icon(
              Icons.circle_outlined,
              color: ThemeColors.primaryColor,
              size: 16.r,
            ),
            Container(
              height: 8.h, // Reduced height
              width: 1.w,
              color: ThemeColors.primaryColor.withOpacity(0.6),
            ),
            Icon(
              Icons.location_on,
              color: ThemeColors.primaryColor,
              size: 16.r,
            ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Source location in single line
              Text(
                ride.source.address,
                style: textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.buttonTextColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6.h), // Reduced space between locations

              // Destination in single line - now matching source style
              Text(
                ride.destination.address,
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

  Widget _buildCarDetails(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Car info
        Expanded(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: ThemeColors.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.directions_car_filled,
                  color: ThemeColors.primaryColor,
                  size: 16.r,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '${ride.car.company} ${ride.car.model}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: ThemeColors.buttonTextColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      ' • ',
                      style: textTheme.bodySmall?.copyWith(
                        color: ThemeColors.buttonTextColor.withOpacity(0.7),
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      ride.car.numberPlate,
                      style: textTheme.bodySmall?.copyWith(
                        color: ThemeColors.buttonTextColor.withOpacity(0.7),
                        fontSize: 12.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 8.w),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Filled seats (passengers)
            for (int i = 0; i < ride.passengers.length; i++)
              Icon(
                Icons.event_seat,
                color: ThemeColors.primaryColor,
                size: 16.r,
              ),
            // Empty seats (available)
            for (int i = 0; i < ride.totalSeats; i++)
              Icon(
                Icons.event_seat,
                color: ThemeColors.backgroundColor,
                size: 16.r,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Cancel Ride Button
        Expanded(
          child: SizedBox(
            height: 33.h,
            child: DialogButton(
              onTap: () {
                _showCancelConfirmation(context);
              },
              text: 'Cancel',
              color: ThemeColors.accentColor,
            ),
          ),
        ),

        SizedBox(width: 10.w),

        // Start Ride Button
        Expanded(
          child: SizedBox(
            height: 33.h, // Added missing height constraint
            child: BlocBuilder<ActiveRidesDriverBloc, ActiveRidesDriverState>(
              builder: (context, state) {
                return DialogButton(
                  onTap: () {
                    context
                        .read<ActiveRidesDriverBloc>()
                        .add(GetRideDataEvent(ride.id));
                  },
                  text: 'Details',
                  color: ThemeColors.primaryColor,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    final bloc = context.read<ActiveRidesDriverBloc>();
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: "Cancel Ride",
        message: "Are you sure you want to cancel this ride?",
        confirmText: "Yes",
        cancelText: "No",
        confirmColor: ThemeColors.accentColor,
        cancelColor: ThemeColors.primaryColor,
        onConfirm: () {
          // Dispatch the event
          bloc.add(CancelRideEvent(ride.id.toString()));
          Navigator.of(context).pop();
        },
        onCancel: () {
          // Close the dialog without canceling
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
