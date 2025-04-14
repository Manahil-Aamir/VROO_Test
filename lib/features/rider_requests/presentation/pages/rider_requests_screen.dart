import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/custom_tab_bar.dart';
import '../bloc/bloc/rider_approved_requests_bloc.dart';
import '../bloc/bloc/rider_pending_requests_bloc.dart';
import '../bloc/events/rider_approved_requests_event.dart';
import '../bloc/events/rider_pending_requests_event.dart';
import 'rider_approved_tab.dart';
import 'rider_pending_tab.dart';

class RiderRequestsScreen extends StatefulWidget {
  const RiderRequestsScreen({super.key});

  @override
  State<RiderRequestsScreen> createState() => _RiderRequestsScreenState();
}

class _RiderRequestsScreenState extends State<RiderRequestsScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    
    // Initial data load
    _loadCurrentTabData();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      _loadCurrentTabData();
    }
  }

  void _loadCurrentTabData() {
    if (_tabController.index == 0) {
      context.read<RiderPendingRequestBloc>().add(FetchPendingRequests());
    } else {
      context.read<RiderApprovedRequestBloc>().add(FetchApprovedRequests());
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
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
              children: const [
                RiderPendingTab(),
                RiderApprovedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
