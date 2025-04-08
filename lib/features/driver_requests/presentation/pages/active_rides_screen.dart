import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/appbar_no_icon.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../shared/widgets/custom_dialog.dart';
import '../bloc/bloc/active_rides_bloc.dart';
import '../bloc/event/active_rides_event.dart';
import '../bloc/state/active_rides_state.dart';
import 'widgets/active_ride_card.dart';

class ActiveRidesScreen extends StatefulWidget {
  final String id;
  const ActiveRidesScreen({super.key, required this.id});

  @override
  State<ActiveRidesScreen> createState() => _ActiveRidesScreenState();
}

class _ActiveRidesScreenState extends State<ActiveRidesScreen> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    // context.read<ActiveRidesBloc>().add(FetchActiveRides('Ali Ahmed 4'));
    context.read<ActiveRidesBloc>().add(FetchActiveRides(user!.uid));
  }

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
        appBar: AppBarNoIcon(heading: 'Your Rides'),
        body: BlocBuilder<ActiveRidesBloc, ActiveRidesState>(
          builder: (context, state) {
            if (state is ActiveRidesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ActiveRidesError) {
              return Center(child: Text(state.message));
            } else if (state is ActiveRidesLoaded) {
              if (state.rides.isEmpty) {
                return const Center(
                  child: Text(
                    'Please create a ride',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.rides.length,
                itemBuilder: (context, index) => ActiveRideCard(
                  ride: state.rides[index],
                ),
              );
            }
            return const Center(child: Text('Fetching rides...'));
          },
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: 1,
        ),
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
