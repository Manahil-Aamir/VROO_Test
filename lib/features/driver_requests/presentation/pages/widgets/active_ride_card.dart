import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/router/navigation.dart';
import '../../../../../core/theme/color/color_theme.dart';
import '../../../domain/entity/active_ride.dart';

class ActiveRideCard extends StatelessWidget {
  final ActiveRideEntity ride;

  const ActiveRideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme; 

    return GestureDetector(
      onTap: () {
        print('ride id: ${ride.id}');
        print('ride id: ${ride.status}');
        context.read<Navigation>().navigateTo(
        '/ride_details',
        arguments: ride.id.toString(),
    );

      },
      child: Card(
        margin: EdgeInsets.all(12.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        color: ThemeColors.primaryColorDark,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row with Driver Info and Date/Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDriverInfo(textTheme),
                  _buildDateTime(textTheme, ride, context),
                ],
              ),
              SizedBox(height: 12.h),
              
              // Centered Route Information with aligned locations
              _buildRouteInfo(textTheme, ride),
              SizedBox(height: 16.h),
              
              // Car Details
              _buildCarDetails(textTheme, ride),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverInfo(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 28.r,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Icon(Icons.person, color: Colors.white, size: 32.r),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amjad Ali',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Icon(Icons.star, color: ThemeColors.primaryColor, size: 18.r),
                SizedBox(width: 6.w),
                Text(
                  '4.3',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteInfo(TextTheme textTheme, ActiveRideEntity ride) {
  return Center(
    child: SizedBox(
      width: 0.8.sw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.rotate(
            angle: -math.pi / 2,
            child: Icon(
              Icons.u_turn_left_rounded,
              color: ThemeColors.buttonTextColor,
              size: 60.r, // Maintain original icon size
            ),
          ),
          SizedBox(width: 4.w),
          Expanded( // <-- Add Expanded here
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLocationText(ride.source.address, textTheme),
                SizedBox(height: 4.h),
                _buildLocationText(ride.destination.address, textTheme),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildLocationText(String text, TextTheme textTheme) {
    return Text(
      text,
      style: textTheme.bodyMedium?.copyWith(
        color: ThemeColors.buttonTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCarDetails(TextTheme textTheme, ActiveRideEntity ride) {
    print('ride total seats: ${ride.totalSeats}');
    print('passenger length: ${ride.passengers.length}');

    return Row(
      children: [
        Icon(Icons.directions_car, color: ThemeColors.primaryColor, size: 34.r),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${ride.car.company} ${ride.car.model}',
              style: textTheme.bodyMedium?.copyWith(
                color: ThemeColors.buttonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
            Row(
              children: [
                Text(
                  ride.car.numberPlate,
                  style: textTheme.bodyMedium?.copyWith(
                    color: ThemeColors.buttonTextColor,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                // Seat icons using for loop
                Row(
                  children: [
                    for (int i = 0; i < ride.passengers.length; i++)
                      Icon(
                        Icons.event_seat,
                        color: ThemeColors.primaryColor, // Same color for all seats
                        size: 18.r,
                      ),
                    for (int i = 0; i < ride.totalSeats; i++)
                      Icon(
                        Icons.event_seat,
                        color: ThemeColors.backgroundColor, // Same color for all seats
                        size: 18.r,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateTime(TextTheme textTheme, ActiveRideEntity ride, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          DateFormat('dd/MM/yyyy').format(ride.date),
          style: textTheme.bodySmall?.copyWith(
            color: ThemeColors.buttonTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(Icons.access_time, color: ThemeColors.primaryColor, size: 16.r),
            SizedBox(width: 6.w),
            Text(
              MaterialLocalizations.of(context).formatTimeOfDay(ride.time), 
              style: textTheme.bodySmall?.copyWith(
                color: ThemeColors.buttonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp
              ),
            ),
          ],
        ),
      ],
    );
  }

}
