import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../bloc/bloc/pending_rides_bloc.dart';
import '../bloc/event/pending_rides_event.dart';
import '../bloc/state/pending_rides_state.dart';
import 'widgets/pending_rides_card.dart';

class PendingRidesScreen extends StatefulWidget {
  final String id;
  const PendingRidesScreen({super.key, required this.id});

  @override
  State<PendingRidesScreen> createState() => _PendingRidesScreenState();
}

class _PendingRidesScreenState extends State<PendingRidesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PendingRidesBloc>().add(FetchPendingRides(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(heading: 'Your Rides'),
      body: BlocBuilder<PendingRidesBloc, PendingRidesState>(
        builder: (context, state) {
          if (state is PendingRidesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PendingRidesError) {
            return Center(child: Text(state.message));
          } else if (state is PendingRidesLoaded) {
            if (state.rides.isEmpty) {
              return const Center(child: Text('No rides available.'));
            }
            return ListView.builder(
              itemCount: state.rides.length,
              itemBuilder: (context, index) => RideDetailCard(
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
