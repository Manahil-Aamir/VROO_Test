import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/appbar_no_icon.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../shared/widgets/custom_dialog.dart';
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
    _tabController = TabController(
      length: 2, 
      vsync: this,
      initialIndex: 1, // Approved tab is index 1
    );
    
    // Fetch both pending and approved rides when screen loads
    context.read<RiderPendingRequestBloc>().add(FetchPendingRequests());
    context.read<RiderApprovedRequestBloc>().add(FetchApprovedRequests());
 }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 2, vsync: this);
  //   _tabController.addListener(_handleTabChange);
    
  //   // Initial data load
  //   _loadCurrentTabData();
  // }

  // void _handleTabChange() {
  //   if (!_tabController.indexIsChanging) {
  //     _loadCurrentTabData();
  //   }
  // }

  // void _loadCurrentTabData() {
  //   if (_tabController.index == 0) {
  //     context.read<RiderPendingRequestBloc>().add(FetchPendingRequests());
  //   } else {
  //     context.read<RiderApprovedRequestBloc>().add(FetchApprovedRequests());
  //   }
  // }

  // @override
  // void dispose() {
  //   _tabController.removeListener(_handleTabChange);
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await _showExitDialog(context);
        if (exitApp) {
          SystemNavigator.pop(); // Closes the app
        }
        return false; // Prevents the default back action
      },
      child: Scaffold(
        appBar: AppBarNoIcon(heading: 'Ride Requests'),
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
        bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: "Exit App",
        message: "Are you sure you want to exit?",
        confirmText: "Yes",
        cancelText: "No",
        confirmColor: Theme.of(context).indicatorColor,
        cancelColor: Theme.of(context).primaryColorDark,
        onConfirm: () {
          Navigator.of(context).pop(true);
        },
        onCancel: () {
          Navigator.of(context).pop(false);
        },
      ),
    ) ??
    false;
  }
}
