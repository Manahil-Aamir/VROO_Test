import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/custom_tab_bar.dart';
import '../../../HomeScreens/presentation/bloc/role_bloc.dart';
import '../../domain/entity/driver_history_entity.dart';
import '../../domain/entity/rider_history_entity.dart';
import '../bloc/bloc/ride_history_bloc.dart';
import '../bloc/event/ride_history_event.dart';
import '../bloc/state/ride_history_state.dart';
import '../widget/ride_history_card.dart';

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
                      print('state: ${state.message}');
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/error.png',
                              width: 300.w,
                              height: 300.h,
                              fit: BoxFit.contain,
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
