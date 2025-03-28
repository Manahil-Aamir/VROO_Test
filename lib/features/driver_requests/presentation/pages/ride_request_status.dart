import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../shared/widgets/custom_top_bar.dart';
import '../bloc/bloc/pending_rides_bloc.dart';
import '../bloc/event/pending_rides_event.dart';
import 'approved_rides_tab.dart';
import 'pending_rides_tab.dart';

class RideRequestStatusScreen extends StatefulWidget {
  final String rideId;
  const RideRequestStatusScreen({super.key, required this.rideId});

  @override
  State<RideRequestStatusScreen> createState() => _RideRequestStatusScreenState();
}

class _RideRequestStatusScreenState extends State<RideRequestStatusScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2, 
      vsync: this,
      initialIndex: 1, // Approved tab is index 1
    );
    
    // Fetch both pending and approved rides when screen loads
    context.read<PendingRidesBloc>().add(FetchPendingRides(widget.rideId));
    // TODO: Add event for fetching approved rides
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(heading: 'Ride Requests'),
      body: Column(
        children: [
          CustomTabBar(
            tabController: _tabController,
            tabTitles: const ['Pending', 'Approved'],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PendingRidesTab(rideId: widget.rideId),
                ApprovedRidesTab(rideId: widget.rideId),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
