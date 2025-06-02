// ride_history_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/custom_tab_bar.dart';
import '../../../HomeScreens/presentation/bloc/role_bloc.dart';
import '../../domain/entity/driver_history_entity.dart';
import '../../domain/entity/rider_history_entity.dart';
import '../bloc/bloc/ride_history_bloc.dart';
import '../bloc/event/ride_history_event.dart';
import '../bloc/state/ride_history_state.dart';

class RideHistoryCard extends StatelessWidget {
  final dynamic ride; // Can be RideEntity or RiderRideEntity
  final bool isCompleted;
  final bool isDriverView;

  const RideHistoryCard({
    Key? key,
    required this.ride,
    required this.isCompleted,
    required this.isDriverView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ThemeColors.primaryColorDark,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateAndTimeRow(textTheme),
            SizedBox(height: 12.h),
            _buildRouteInfo(textTheme),
            SizedBox(height: 12.h),
            if (isDriverView && ride is RideEntity)
              _buildDriverViewContent(context, textTheme, ride as RideEntity)
            else if (!isDriverView && ride is RiderRideEntity)
              _buildRiderViewContent(context, textTheme, ride as RiderRideEntity),
            SizedBox(height: 12.h),
            _buildBottomRow(context, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildDateAndTimeRow(TextTheme textTheme) {
    // Parse date string to DateTime
    DateTime? parsedDate;
    DateTime? parsedTime;
    try {
      String dateStr = '';
      String timeStr = '';
      if (ride is RideEntity) {
        dateStr = (ride as RideEntity).date;
        timeStr = (ride as RideEntity).departureTime;
      } else if (ride is RiderRideEntity) {
        dateStr = (ride as RiderRideEntity).date;
        timeStr = (ride as RiderRideEntity).rider.pickupTimeRange.min as String;
      }
      parsedDate = DateTime.parse(dateStr);
      parsedTime = DateTime.parse(timeStr);
    } catch (e) {
      // If parsing fails, use current date/time
      parsedDate = DateTime.now();
      parsedTime = DateTime.now();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 14.r, color: ThemeColors.primaryColor),
            SizedBox(width: 6.w),
            Text(
              DateFormat('dd MMM yyyy').format(parsedDate),
              style: textTheme.labelMedium?.copyWith(
                fontSize: 13.sp,
                color: ThemeColors.buttonTextColor,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.access_time_rounded, size: 14.r, color: ThemeColors.primaryColor),
            SizedBox(width: 6.w),
            Text(
              DateFormat('h:mm a').format(parsedTime),
              style: textTheme.labelMedium?.copyWith(
                fontSize: 13.sp,
                color: ThemeColors.buttonTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteInfo(TextTheme textTheme) {
    String sourceAddress = '';
    String destinationAddress = '';

    if (ride is RideEntity) {
      sourceAddress = (ride as RideEntity).source.address;
      destinationAddress = (ride as RideEntity).destination.address;
    } else if (ride is RiderRideEntity) {
      sourceAddress = (ride as RiderRideEntity).source.address;
      destinationAddress = (ride as RiderRideEntity).destination.address;
    }

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
              height: 8.h,
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
              Text(
                sourceAddress,
                style: textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.buttonTextColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6.h),
              Text(
                destinationAddress,
                style: textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.buttonTextColor,
                  fontSize: 14.sp,
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

  Widget _buildDriverViewContent(BuildContext context, TextTheme textTheme, RideEntity rideEntity) {
    return _buildCarInfo(textTheme, rideEntity.car);
  }

  Widget _buildRiderViewContent(BuildContext context, TextTheme textTheme, RiderRideEntity riderEntity) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: ThemeColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Driver info on the left
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: ThemeColors.primaryColor,
                  child: Text(
                    riderEntity.driverName.isNotEmpty 
                        ? riderEntity.driverName[0].toUpperCase() 
                        : 'D',
                    style: textTheme.titleMedium?.copyWith(
                      color: ThemeColors.buttonTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        riderEntity.driverName,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: ThemeColors.buttonTextColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.directions_car_filled_rounded, 
                            color: ThemeColors.primaryColor, 
                            size: 16.r
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${riderEntity.car.company} ${riderEntity.car.model}',
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              color: ThemeColors.buttonTextColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Fare on the right
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Fare',
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 11.sp,
                    color: ThemeColors.buttonTextColor.withOpacity(0.8),
                  ),
                ),
                Text(
                  'Rs. ${riderEntity.fare.toStringAsFixed(2)}',
                  style: textTheme.bodyLarge?.copyWith(
                    fontSize: 16.sp,
                    color: ThemeColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow(BuildContext context, TextTheme textTheme) {
    double totalFare = 0.0;
    List<PassengerEntity> passengers = [];

    if (ride is RideEntity) {
      totalFare = (ride as RideEntity).fare;
      passengers = (ride as RideEntity).passengers;
    } else if (ride is RiderRideEntity) {
      totalFare = (ride as RiderRideEntity).fare;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Passengers section (only for driver view)
        if (isDriverView && passengers.isNotEmpty)
          _buildPassengersIcons(context, textTheme, passengers)
        else
          SizedBox.shrink(),
        
        // Show fare only in driver view (for rider view, it's already in the driver info container)
        if (isDriverView)
          Text(
            'Rs. ${totalFare.toStringAsFixed(2)}',
            style: textTheme.bodyLarge?.copyWith(
              fontSize: 16.sp,
              color: ThemeColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          )
        else
          SizedBox.shrink(),
      ],
    );
  }

  // Widget _buildDriverInfo(TextTheme textTheme, RiderRideEntity riderEntity) {
  //   return Container(
  //     padding: EdgeInsets.all(10.r),
  //     decoration: BoxDecoration(
  //       color: ThemeColors.primaryColor.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(12.r),
  //     ),
  //     child: Row(
  //       children: [
  //         CircleAvatar(
  //           radius: 20.r,
  //           backgroundColor: ThemeColors.primaryColor,
  //           child: Text(
  //             riderEntity.driverName.isNotEmpty ? riderEntity.driverName[0].toUpperCase() : 'D',
  //             style: textTheme.titleMedium?.copyWith(
  //               color: ThemeColors.buttonTextColor,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 14.sp,
  //             ),
  //           ),
  //         ),
  //         SizedBox(width: 12.w),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 riderEntity.driverName,
  //                 style: textTheme.bodyLarge?.copyWith(
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 14.sp,
  //                   color: ThemeColors.buttonTextColor,
  //                 ),
  //               ),
  //               SizedBox(height: 2.h),
  //               Row(
  //                 children: [
  //                   Icon(Icons.directions_car_filled_rounded, 
  //                       color: ThemeColors.primaryColor, size: 16.r),
  //                   SizedBox(width: 4.w),
  //                   Text(
  //                     '${riderEntity.car.company} ${riderEntity.car.model}',
  //                     style: textTheme.bodySmall?.copyWith(
  //                       fontSize: 12.sp,
  //                       color: ThemeColors.buttonTextColor.withOpacity(0.8),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildCarInfo(TextTheme textTheme, dynamic car) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: ThemeColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.directions_car_filled_rounded, 
                  color: ThemeColors.primaryColor, size: 16.r),
              SizedBox(width: 8.w),
              Text(
                '${car.company} ${car.model} ${car.color}',
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: ThemeColors.buttonTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            car.numberPlate ?? 'N/A',
            style: textTheme.bodySmall?.copyWith(
              fontSize: 11.sp,
              color: ThemeColors.buttonTextColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildBottomRow(BuildContext context, TextTheme textTheme) {
  //   double totalFare = 0.0;
  //   List<PassengerEntity> passengers = [];

  //   if (ride is RideEntity) {
  //     totalFare = (ride as RideEntity).fare;
  //     passengers = (ride as RideEntity).passengers;
  //   } else if (ride is RiderRideEntity) {
  //     totalFare = (ride as RiderRideEntity).fare;
  //   }

  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       // Passengers section (only for driver view)
  //       if (isDriverView && passengers.isNotEmpty)
  //         _buildPassengersIcons(context, textTheme, passengers)
  //       else
  //         SizedBox.shrink(),
        
  //       // Total fare
  //       Text(
  //         'Rs. ${totalFare.toStringAsFixed(2)}',
  //         style: textTheme.bodyLarge?.copyWith(
  //           fontSize: 16.sp,
  //           color: ThemeColors.primaryColor,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildPassengersIcons(BuildContext context, TextTheme textTheme, List<PassengerEntity> passengers) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show up to 4 passenger icons, then +X for remaining
        ...passengers.take(4).map((passenger) {
          return GestureDetector(
            onTap: () => _showPassengerInfo(context, passenger),
            child: Container(
              margin: EdgeInsets.only(right: 4.w),
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: ThemeColors.primaryColor,
                child: Icon(
                  passenger.gender.toLowerCase() == 'male' 
                      ? Icons.man 
                      : Icons.woman,
                  size: 18.r,
                  color: ThemeColors.buttonTextColor,
                ),
              ),
            ),
          );
        }).toList(),
        
        // Show +X if more than 4 passengers
        if (passengers.length > 4)
          GestureDetector(
            onTap: () => _showAllPassengersBottomSheet(context, passengers),
            child: Container(
              margin: EdgeInsets.only(left: 2.w),
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: ThemeColors.primaryColor.withOpacity(0.7),
                child: Text(
                  '+${passengers.length - 4}',
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    color: ThemeColors.buttonTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showPassengerInfo(BuildContext context, PassengerEntity passenger) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      final textTheme = Theme.of(dialogContext).textTheme;
      return Dialog(
        backgroundColor: ThemeColors.primaryColorDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar
              CircleAvatar(
                radius: 30.r,
                backgroundColor: ThemeColors.primaryColor,
                child: Icon(
                  passenger.gender.toLowerCase() == 'male'
                      ? Icons.man
                      : Icons.woman,
                  size: 30.r,
                  color: ThemeColors.buttonTextColor,
                ),
              ),
              SizedBox(height: 16.h),

              // Name
              Text(
                passenger.name,
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  color: ThemeColors.buttonTextColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),

              // Status
              Text(
                'Status: ${passenger.status}',
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: passenger.status.toLowerCase() == 'completed'
                      ? Colors.green
                      : ThemeColors.buttonTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.h),

              // Fare
              Text(
                'Rs. ${passenger.fare.toStringAsFixed(2)}',
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  color: ThemeColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // ETA (optional)
              if (passenger.eta.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Text(
                  'ETA: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(passenger.eta).toLocal())}',
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: ThemeColors.buttonTextColor.withOpacity(0.8),
                  ),
                ),
              ],

              SizedBox(height: 20.h),

              // Close button
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'Close',
                  style: textTheme.bodyMedium?.copyWith(
                    color: ThemeColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  void _showAllPassengersBottomSheet(BuildContext context, List<PassengerEntity> passengers) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeColors.primaryColorDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      isScrollControlled: true,
      builder: (sheetContext) {
        final textTheme = Theme.of(sheetContext).textTheme;
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.7,
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: ThemeColors.buttonTextColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              
              // Title
              Text(
                'Passengers (${passengers.length})',
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 18.sp,
                  color: ThemeColors.buttonTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              
              // Passengers list
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: passengers.length,
                  itemBuilder: (context, index) {
                    final passenger = passengers[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(sheetContext);
                        _showPassengerInfo(context, passenger);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: ThemeColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor: ThemeColors.primaryColor,
                              child: Icon(
                                passenger.gender.toLowerCase() == 'male' 
                                    ? Icons.man 
                                    : Icons.woman,
                                size: 20.r,
                                color: ThemeColors.buttonTextColor,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ID: ${passenger.riderId}',
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontSize: 14.sp,
                                      color: ThemeColors.buttonTextColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    passenger.gender,
                                    style: textTheme.bodySmall?.copyWith(
                                      fontSize: 12.sp,
                                      color: ThemeColors.buttonTextColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: ThemeColors.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                'Rs. ${passenger.fare.toStringAsFixed(2)}',
                                style: textTheme.bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  color: ThemeColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }
}

// Updated ride_history_screen.dart
class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({Key? key}) : super(key: key);

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isDriverView = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHistoryBasedOnRole();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadHistoryBasedOnRole() {
    final roleState = context.read<RoleBloc>().state;
    _isDriverView = roleState.role == 'Driver';
    
    if (_isDriverView) {
      context.read<RideHistoryBloc>().add(LoadDriverHistory());
    } else {
      context.read<RideHistoryBloc>().add(LoadRiderHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        heading: 'Ride History',
      ),
      body: BlocConsumer<RoleBloc, RoleState>(
        listener: (context, roleState) {
          _loadHistoryBasedOnRole();
        },
        builder: (context, roleState) {
          return Column(
            children: [
              CustomTabBar(
                tabController: _tabController,
                tabTitles: const ['Completed', 'Cancelled'],
              ),
              Expanded(
                child: BlocBuilder<RideHistoryBloc, RideHistoryState>(
                  builder: (context, state) {
                    if (state is RideHistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RideHistoryError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48.r,
                              color: Colors.red,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Error: ${state.message}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: _loadHistoryBasedOnRole,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (_isDriverView && state is DriverHistoryLoaded) {
                      return _buildDriverHistoryTabs(state.history);
                    } else if (!_isDriverView && state is RiderHistoryLoaded) {
                      return _buildRiderHistoryTabs(state.history);
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 48.r,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No ride history available',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey,
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
        },
      ),
    );
  }

  Widget _buildDriverHistoryTabs(DriverHistoryEntity history) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildRidesList(history.completedRides, true, true),
        _buildRidesList(history.cancelledRides, false, true),
      ],
    );
  }

  Widget _buildRiderHistoryTabs(RiderHistoryEntity history) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildRidesList(history.completedRides, true, false),
        _buildRidesList(history.cancelledRides, false, false),
      ],
    );
  }

  Widget _buildRidesList(List<dynamic> rides, bool isCompleted, bool isDriverView) {
    if (rides.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.check_circle_outline : Icons.cancel_outlined,
              size: 48.r,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              'No ${isCompleted ? 'completed' : 'cancelled'} rides',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<RideHistoryBloc>().add(RefreshHistory(isDriverView));
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: rides.length,
        itemBuilder: (context, index) {
          return RideHistoryCard(
            ride: rides[index],
            isCompleted: isCompleted,
            isDriverView: isDriverView,
          );
        },
      ),
    );
  }
}
