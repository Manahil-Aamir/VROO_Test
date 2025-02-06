import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
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
    context.read<ActiveRidesBloc>().add(FetchActiveRides('hritika_3030'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(heading: 'Your Rides'),
      body: BlocBuilder<ActiveRidesBloc, ActiveRidesState>(
        builder: (context, state) {
          if (state is ActiveRidesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ActiveRidesError) {
            return Center(child: Text(state.message));
          } else if (state is ActiveRidesLoaded) {
            return ListView.builder(
              itemCount: state.rides.length,
              itemBuilder: (context, index) => ActiveRideCard(
                ride: state.rides[index],
              ),
            );
          }
          // Handle the "initial" state gracefully
          return const Center(child: Text('Fetching rides...'));
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: 1,
      ),
    );
  }
}
