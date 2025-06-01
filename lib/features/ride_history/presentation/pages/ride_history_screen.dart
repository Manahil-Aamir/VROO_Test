// ride_history_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/color/color_theme.dart';
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
            _buildStatusAndDateRow(textTheme),
            if (isCompleted) 
              Divider(color: ThemeColors.buttonTextColor.withOpacity(0.2), height: 18.h),
            if (isDriverView && ride is RideEntity)
              _buildDriverViewContent(context, textTheme, ride as RideEntity)
            else if (!isDriverView && ride is RiderRideEntity)
              _buildRiderViewContent(context, textTheme, ride as RiderRideEntity),
            SizedBox(height: 12.h),
            _buildRouteInfo(textTheme),
            SizedBox(height: 12.h),
            _buildFareInfo(textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusAndDateRow(TextTheme textTheme) {
    // Parse date string to DateTime
    DateTime? parsedDate;
    try {
      String dateStr = '';
      if (ride is RideEntity) {
        dateStr = (ride as RideEntity).date;
      } else if (ride is RiderRideEntity) {
        dateStr = (ride as RiderRideEntity).date;
      }
      parsedDate = DateTime.parse(dateStr);
    } catch (e) {
      // If parsing fails, use current date
      parsedDate = DateTime.now();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isCompleted 
                ? Colors.green.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCompleted ? Icons.check_circle : Icons.cancel,
                size: 14.r,
                color: isCompleted ? Colors.green : Colors.red,
              ),
              SizedBox(width: 4.w),
              Text(
                isCompleted ? 'Completed' : 'Cancelled',
                style: textTheme.labelMedium?.copyWith(
                  fontSize: 12.sp,
                  color: isCompleted ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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
      ],
    );
  }

  Widget _buildDriverViewContent(BuildContext context, TextTheme textTheme, RideEntity rideEntity) {
    return Column(
      children: [
        if (isCompleted) _buildDepartureTimeRow(textTheme, rideEntity.departureTime),
        if (isCompleted && rideEntity.passengers.isNotEmpty) 
          _buildPassengersInfo(textTheme, rideEntity.passengers),
        if (isCompleted) _buildCarInfo(textTheme, rideEntity.car),
      ],
    );
  }

  Widget _buildRiderViewContent(BuildContext context, TextTheme textTheme, RiderRideEntity riderEntity) {
    return Column(
      children: [
        if (isCompleted) _buildDepartureTimeRow(textTheme, riderEntity.departureTime),
        if (isCompleted) _buildDriverInfo(textTheme, riderEntity),
      ],
    );
  }

  Widget _buildDepartureTimeRow(TextTheme textTheme, String departureTime) {
    // Parse departure time
    DateTime? parsedTime;
    try {
      parsedTime = DateTime.parse(departureTime);
    } catch (e) {
      // If parsing fails, use current time
      parsedTime = DateTime.now();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(Icons.access_time_rounded, size: 16.r, color: ThemeColors.primaryColor),
          SizedBox(width: 8.w),
          Text(
            DateFormat('h:mm a').format(parsedTime),
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: ThemeColors.buttonTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfo(TextTheme textTheme, RiderRideEntity riderEntity) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: ThemeColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: ThemeColors.primaryColor,
            child: Text(
              riderEntity.driverName.isNotEmpty ? riderEntity.driverName[0].toUpperCase() : 'D',
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
                    Icon(Icons.directions_car_filled_rounded, 
                        color: ThemeColors.primaryColor, size: 16.r),
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
    );
  }

  Widget _buildPassengersInfo(TextTheme textTheme, List<PassengerEntity> passengers) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Passengers (${passengers.length}):',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              color: ThemeColors.buttonTextColor,
            ),
          ),
          SizedBox(height: 6.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: passengers.map((passenger) {
                return Container(
                  margin: EdgeInsets.only(right: 6.w),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: ThemeColors.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        passenger.gender.toLowerCase() == 'male' 
                            ? Icons.man 
                            : Icons.woman,
                        size: 14.r,
                        color: ThemeColors.primaryColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '\$${passenger.fare.toStringAsFixed(0)}',
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: ThemeColors.buttonTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarInfo(TextTheme textTheme, dynamic car) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: ThemeColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.directions_car_filled_rounded, 
              color: ThemeColors.primaryColor, size: 16.r),
          SizedBox(width: 8.w),
          Text(
            '${car.company} ${car.model} • ${car.color}',
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 13.sp,
              color: ThemeColors.buttonTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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

  Widget _buildFareInfo(TextTheme textTheme) {
    double totalFare = 0.0;

    if (ride is RideEntity) {
      totalFare = (ride as RideEntity).fare;
    } else if (ride is RiderRideEntity) {
      totalFare = (ride as RiderRideEntity).fare;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ThemeColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Fare',
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: ThemeColors.buttonTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '\$${totalFare.toStringAsFixed(2)}',
            style: textTheme.bodyLarge?.copyWith(
              fontSize: 16.sp,
              color: ThemeColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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

  void _switchRole() {
    context.read<RoleBloc>().add(SwitchRoleEvent());
    _loadHistoryBasedOnRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          BlocBuilder<RoleBloc, RoleState>(
            builder: (context, roleState) {
              return IconButton(
                icon: const Icon(Icons.swap_horiz),
                onPressed: _switchRole,
                tooltip: 'Switch to ${roleState.role == 'Driver' ? 'Rider' : 'Driver'} view',
              );
            },
          ),
        ],
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
