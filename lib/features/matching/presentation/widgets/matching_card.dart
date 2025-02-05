import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

// Define colors beforehand
const Color kGrayColor = Color(0xFF434143);
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kOrangeColor = Color(0xFFEC8825);

class MatchCard extends StatelessWidget {
  final String driverName;
  final double rating;
  final int trips;
  final String source;
  final String destination;
  final int fare;
  final String carModel;
  final int totalSeats;
  final int filledSeats;
  final String estimatedArrivalTime;

  const MatchCard({
    super.key,
    required this.driverName,
    required this.rating,
    required this.trips,
    required this.source,
    required this.destination,
    required this.fare,
    required this.carModel,
    required this.totalSeats,
    required this.filledSeats,
    required this.estimatedArrivalTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String cleanedDate = estimatedArrivalTime.replaceAll(' GMT', '');
    DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss");
    DateTime parsedDate = dateFormat.parse(cleanedDate);
    String formattedDate = DateFormat.jm().format(parsedDate);

    Text('Estimated Arrival: $formattedDate');

    Text('Estimated Arrival: $formattedDate');

    return SizedBox(
      width: 363.w,
      height: 228.h,
      child: Card(
        color: theme.primaryColorDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        elevation: 5.0.h,
        shadowColor: theme.primaryColorLight,
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Driver name, avatar, and fare
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24.0.r,
                        backgroundColor: theme.scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 22.0.r,
                          backgroundColor: theme.primaryColorDark,
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: theme.primaryColor,
                            size: 24.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.0.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driverName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.scaffoldBackgroundColor,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star_rounded,
                                  color: theme.primaryColor, size: 14.0.sp),
                              SizedBox(width: 4.0.w),
                              Text(
                                '$rating - $trips Trips',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.scaffoldBackgroundColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'Rs $fare',
                    style: TextStyle(
                      color: kOrangeColor,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              // Source and destination
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    // Curved arrow and source/destination
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/vectors/arrow.svg',
                          width: 50.0,
                          height: 50.0,
                        ),
                        SizedBox(width: 4.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              source,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.scaffoldBackgroundColor,
                              ),
                            ),
                            SizedBox(height: 4.0.h),
                            Text(
                              destination,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.scaffoldBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.0.h),
              // Car model, seat details, and join button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/vectors/car.svg',
                            width: 16.0.w,
                            height: 16.0.h,
                            color: kWhiteColor,
                          ),
                          SizedBox(width: 4.0.w),
                          Text(
                            carModel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.scaffoldBackgroundColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0.h),
                      Row(
                        children: List.generate(totalSeats, (index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.0),
                            child: Container(
                              width: 16.0.w,
                              height: 16.0.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: index < filledSeats
                                    ? LinearGradient(
                                        colors: [
                                          theme.primaryColor,
                                          theme.primaryColor.withOpacity(0.5),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : LinearGradient(
                                        colors: [
                                          theme.primaryColorDark,
                                          theme.primaryColorDark
                                              .withOpacity(0.5),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 4.0.h),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor.withAlpha(61),
                          borderRadius: BorderRadius.circular(10.0.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 4.0.h,
                          horizontal: 8.0.w,
                        ),
                        child: Text(
                          'Estimated Time: $formattedDate',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 106.0.w,
                    height: 45.0.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0.r),
                        ),
                        padding:
                            EdgeInsets.zero, // Removes padding for exact sizing
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.primaryColor,
                              theme.primaryColor.withOpacity(0.5)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8.0.r),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Join',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.primaryColorDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
