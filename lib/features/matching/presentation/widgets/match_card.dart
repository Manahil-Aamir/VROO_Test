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
import '../bloc/bloc/insights_bloc.dart';
import '../bloc/event/insights_event.dart';
import '../bloc/state/insights_state.dart';

class RideMatchCard extends StatelessWidget {
  final MatchingRideModel match;
  final String rideRequestId;

  const RideMatchCard({
    super.key,
    required this.match,
    required this.rideRequestId,
  });

  String getRiderId() {
    final user = FirebaseAuth.instance.currentUser!;
    return user.uid;
  }

  String _getDriverInitials() {
    final driverName = match.driverName;
    final nameParts = driverName.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}';
    }
    return driverName.isNotEmpty ? driverName[0] : '';
  }

  // void _showInsightsModal(BuildContext context) {
  //   final insightsBloc = context.read<DriverInsightsBloc>();
  //   insightsBloc.add(LoadDriverInsights(match.driverId));
  //   showDialog(
  //     context: context,
  //     builder: (context) => Theme(
  //       data: Theme.of(context).copyWith(
  //         dialogTheme: DialogTheme(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(16.r),
  //           ),
  //           backgroundColor: ThemeColors.primaryColorDark,
  //         ),
  //       ),
  //       child: BlocProvider.value(
  //         value: insightsBloc,
  //         child: Dialog(
  //           child: Container(
  //             constraints: BoxConstraints(
  //               maxWidth: MediaQuery.of(context).size.width * 0.85,
  //               maxHeight: MediaQuery.of(context).size.height * 0.6,
  //             ),
  //             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       'Driver Insights',
  //                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
  //                         color: ThemeColors.buttonTextColor,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 18.sp,
  //                       ),
  //                     ),
  //                     IconButton(
  //                       icon: Icon(Icons.close, size: 22.r),
  //                       color: ThemeColors.buttonTextColor.withOpacity(0.7),
  //                       onPressed: () => Navigator.pop(context),
  //                       padding: EdgeInsets.zero,
  //                       constraints: BoxConstraints(),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 12.h),
  //                 Divider(
  //                   color: ThemeColors.buttonTextColor.withOpacity(0.2),
  //                   height: 1.h,
  //                 ),
  //                 SizedBox(height: 16.h),
  //                 Expanded(
  //                   child: SingleChildScrollView(
  //                     child: BlocBuilder<DriverInsightsBloc, DriverInsightsState>(
  //                       builder: (context, state) {
  //                         if (state is DriverInsightsLoading) {
  //                           return Center(
  //                             child: Padding(
  //                               padding: EdgeInsets.symmetric(vertical: 24.h),
  //                               child: CircularProgressIndicator(
  //                                 color: ThemeColors.primaryColor,
  //                               ),
  //                             ),
  //                           );
  //                         } else if (state is DriverInsightsError) {
  //                           print(state.message);
  //                           return Center(
  //                             child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 Icon(
  //                                   Icons.error_outline,
  //                                   color: Colors.red,
  //                                   size: 48.r,
  //                                 ),
  //                                 SizedBox(height: 16.h),
  //                                 Text(
  //                                   'Failed to load insights',
  //                                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                                     color: ThemeColors.buttonTextColor,
  //                                   ),
  //                                 ),
  //                                 SizedBox(height: 8.h),
  //                                 Text(
  //                                   'Please try again later.',
  //                                   // state.message,
  //                                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //                                     color: Colors.red.withOpacity(0.8),
  //                                   ),
  //                                   textAlign: TextAlign.center,
  //                                 ),
  //                                 SizedBox(height: 16.h),
  //                                 ElevatedButton(
  //                                   onPressed: () {
  //                                     context.read<DriverInsightsBloc>().add(
  //                                       LoadDriverInsights(match.driverId),
  //                                     );
  //                                   },
  //                                   style: ElevatedButton.styleFrom(
  //                                     backgroundColor: ThemeColors.primaryColor,
  //                                     foregroundColor: ThemeColors.buttonTextColor,
  //                                     padding: EdgeInsets.symmetric(
  //                                       horizontal: 24.w,
  //                                       vertical: 10.h,
  //                                     ),
  //                                     shape: RoundedRectangleBorder(
  //                                       borderRadius: BorderRadius.circular(8.r),
  //                                     ),
  //                                   ),
  //                                   child: Text('Retry'),
  //                                 ),
  //                               ],
  //                             ),
  //                           );
  //                         } else if (state is DriverInsightsLoaded) {
  //                           if (state.insights.trim().isNotEmpty) {
  //                             return Container(
  //                               padding: EdgeInsets.symmetric(horizontal: 8.w),
  //                               child: Text(
  //                                 state.insights,
  //                                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                                   color: ThemeColors.buttonTextColor.withOpacity(0.9),
  //                                   height: 1.5,
  //                                   fontSize: 14.sp,
  //                                 ),
  //                               ),
  //                             );
  //                           }
  //                         }
  //                         return Center(
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Icon(
  //                                 Icons.insights,
  //                                 size: 48.r,
  //                                 color: ThemeColors.buttonTextColor.withOpacity(0.5),
  //                               ),
  //                               SizedBox(height: 16.h),
  //                               Text(
  //                                 'No insights available',
  //                                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
  //                                   color: ThemeColors.buttonTextColor.withOpacity(0.8),
  //                                 ),
  //                               ),
  //                               SizedBox(height: 8.h),
  //                               Text(
  //                                 'Check back later for driver insights',
  //                                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //                                   color: ThemeColors.buttonTextColor.withOpacity(0.6),
  //                                 ),
  //                                 textAlign: TextAlign.center,
  //                               ),
  //                             ],
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showInsightsModal(BuildContext context) {
    final insightsBloc = context.read<DriverInsightsBloc>();
    insightsBloc.add(LoadDriverInsights(match.driverId));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // makes it full-screen
      backgroundColor:
          Colors.transparent, // to apply custom radius and background
      builder: (context) {
        return BlocProvider.value(
          value: insightsBloc,
          child: DraggableScrollableSheet(
            initialChildSize: 0.40,
            minChildSize: 0.2,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) => Container(
              decoration: BoxDecoration(
                color: ThemeColors.primaryColorDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Driver Insights',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: ThemeColors.buttonTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 22.r),
                        color: ThemeColors.primaryColor.withOpacity(0.7),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Divider(
                    color: ThemeColors.buttonTextColor.withOpacity(0.2),
                    height: 1.h,
                  ),
                  SizedBox(height: 16.h),

                  // Body
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child:
                          BlocBuilder<DriverInsightsBloc, DriverInsightsState>(
                        builder: (context, state) {
                          if (state is DriverInsightsLoading) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 100.h, 0, 0),
                                child: CircularProgressIndicator(
                                  color: ThemeColors.primaryColor,
                                ),
                              ),
                            );
                          } else if (state is DriverInsightsError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline,
                                      color: Colors.red, size: 48.r),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Failed to load insights',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: ThemeColors.buttonTextColor,
                                        ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Please try again later.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.red.withOpacity(0.8),
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16.h),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<DriverInsightsBloc>().add(
                                            LoadDriverInsights(match.driverId),
                                          );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ThemeColors.primaryColor,
                                      foregroundColor:
                                          ThemeColors.buttonTextColor,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.w, vertical: 10.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    child: Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          } else if (state is DriverInsightsLoaded) {
                            if (state.insights.trim().isNotEmpty) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Text(
                                  state.insights,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: ThemeColors.buttonTextColor
                                            .withOpacity(0.9),
                                        height: 1.5,
                                        fontSize: 14.sp,
                                      ),
                                ),
                              );
                            }
                          }
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 36.h),
                                Icon(Icons.insights,
                                    size: 48.r,
                                    color: ThemeColors.primaryColor
                                        .withOpacity(0.5)),
                                SizedBox(height: 16.h),
                                Text(
                                  'No insights available',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: ThemeColors.buttonTextColor
                                            .withOpacity(0.8),
                                      ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Check back later for driver insights',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: ThemeColors.buttonTextColor
                                            .withOpacity(0.6),
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
        InitialsCircleAvatar(
          initials: _getDriverInitials(),
          radius: 20,
        ),
        SizedBox(width: 12.w),
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
                        Row(
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
                            IconButton(
                              icon: Icon(Icons.insights, size: 20.r),
                              color: ThemeColors.primaryColor,
                              onPressed: () => _showInsightsModal(context),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 14.r),
                            SizedBox(width: 4.w),
                            Text(
                              "4.5",
                              style: textTheme.bodySmall?.copyWith(
                                color: ThemeColors.buttonTextColor
                                    .withOpacity(0.8),
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
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 12.r, color: ThemeColors.primaryColor),
                          SizedBox(width: 4.w),
                          Text(
                            DateFormat('dd-MM-yyyy').format(match.date),
                            style: textTheme.bodySmall?.copyWith(
                              color: ThemeColors.buttonTextColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 12.r, color: ThemeColors.primaryColor),
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
            Icon(Icons.circle_outlined,
                color: ThemeColors.primaryColor, size: 16.r),
            Container(
              height: 8.h,
              width: 1.w,
              color: ThemeColors.primaryColor.withOpacity(0.6),
            ),
            Icon(Icons.location_on,
                color: ThemeColors.primaryColor, size: 16.r),
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < occupiedSeats; i++)
              Icon(Icons.event_seat,
                  color: ThemeColors.primaryColor, size: 16.r),
            for (int i = 0; i < availableSeats; i++)
              Icon(Icons.event_seat,
                  color: ThemeColors.backgroundColor, size: 16.r),
          ],
        ),
      ],
    );
  }

  Widget _buildFareAndJoinButton(BuildContext context, TextTheme textTheme) {
    return Row(
      children: [
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
        ElevatedButton(
          onPressed: () {
            final joinData = {
              "rideId": match.id,
              "rideRequestId": rideRequestId,
              "driverId": match.driverId,
              "riderId": getRiderId(),
            };
            context
                .read<MatchingBloc>()
                .add(JoinRideRequestEvent(joinData: joinData));
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
