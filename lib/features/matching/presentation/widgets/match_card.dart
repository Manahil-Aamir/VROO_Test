import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/initials_circle_avatar.dart';
import '../../../matching/data/models/matching_rides_model.dart';
import '../bloc/bloc/matching_bloc.dart';
import '../bloc/event/matching_event.dart';

class RideMatchCard extends StatelessWidget {
  final MatchingRideModel match;
  final String rideRequestId;

  const RideMatchCard({
    Key? key, 
    required this.match,
    required this.rideRequestId,
  }) : super(key: key);

  String getRiderId() {
    final FirebaseAuth firebaseAuth =
        FirebaseAuth.instance; // Initialize FirebaseAuth
    final User user = firebaseAuth.currentUser!; // Get current user
    return user.uid; // Return UID or null if user is not logged in
  }

  String _getDriverInitials() {
    final driverName = match.driverName;
    final nameParts = driverName.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}';
    }
    return driverName.isNotEmpty ? driverName[0] : '';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
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
            _buildDriverInfoWithDate(context, textTheme),
            Divider(
              color: ThemeColors.buttonTextColor.withOpacity(0.15),
              height: 16.h,
              thickness: 0.5,
            ),
            _buildRouteInfo(textTheme),
            SizedBox(height: 10.h),
            _buildCarDetailsAndSeats(textTheme),
            SizedBox(height: 14.h),
            _buildFareAndJoinButton(context, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverInfoWithDate(BuildContext context, TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Driver avatar
        InitialsCircleAvatar(
          initials: _getDriverInitials(),
          radius: 20,
        ),
        SizedBox(width: 12.w),
        
        // Driver name, ratings, date and departure time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match.driverName,
                          style: textTheme.bodyLarge?.copyWith(
                            color: ThemeColors.buttonTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 14.r),
                            SizedBox(width: 4.w),
                            Text(
                              "4.5", // NOTE: Rating not available in MatchingRideModel
                              style: textTheme.bodySmall?.copyWith(
                                color: ThemeColors.buttonTextColor.withOpacity(0.8),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Date
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12.r, color: ThemeColors.primaryColor),
                          SizedBox(width: 4.w),
                          Text(
                            //format the date
                            DateFormat('dd-MM-yyyy').format(match.date),
                            // match.date,
                            style: textTheme.bodySmall?.copyWith(
                              color: ThemeColors.buttonTextColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      // Departure time with time icon
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 12.r, color: ThemeColors.primaryColor),
                          SizedBox(width: 4.w),
                          Text(
                            DateFormat('h:mm a').format(match.departureTime),
                            style: textTheme.bodySmall?.copyWith(
                              color: ThemeColors.buttonTextColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteInfo(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(Icons.circle_outlined, color: ThemeColors.primaryColor, size: 16.r),
            Container(
              height: 8.h,
              width: 1.w,
              color: ThemeColors.primaryColor.withOpacity(0.6),
            ),
            Icon(Icons.location_on, color: ThemeColors.primaryColor, size: 16.r),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                match.source.address,
                style: textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.buttonTextColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6.h),
              Text(
                match.destination.address,
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

  Widget _buildCarDetailsAndSeats(TextTheme textTheme) {
    final occupiedSeats = match.passengers.length;
    final availableSeats = match.numOfSeats - occupiedSeats;
    
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
                      '${match.car.company} ${match.car.model}',
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
                      match.car.numberPlate,
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

        // Seat icons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < occupiedSeats; i++)
              Icon(
                Icons.event_seat,
                color: ThemeColors.primaryColor,
                size: 16.r,
              ),
            for (int i = 0; i < availableSeats; i++)
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

  Widget _buildFareAndJoinButton(BuildContext context, TextTheme textTheme) {
    return Row(
      children: [
        // Fare
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: ThemeColors.primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            "Rs. ${match.fare.toStringAsFixed(2)}",
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: ThemeColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Spacer(), 

        // Join Button
        ElevatedButton(
          onPressed: () {
            final joinData = {
              "rideId": match.id,
              "rideRequestId": rideRequestId,
              "driverId": match.driverId, 
              "riderId": getRiderId(),
            };
            print("Join data: $joinData");
            context.read<MatchingBloc>().add(JoinRideRequestEvent(joinData: joinData));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.primaryColor,
            foregroundColor: ThemeColors.buttonTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          ),
          child: Text(
            "Request to Join",
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: ThemeColors.buttonTextColor,
            ),
          ),
        ),
      
      
      ],
    );
  }



}
