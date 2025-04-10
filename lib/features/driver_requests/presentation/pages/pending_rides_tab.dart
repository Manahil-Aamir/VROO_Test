import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/error_dialog.dart';
import '../bloc/bloc/approved_rides_bloc.dart';
import '../bloc/bloc/pending_rides_bloc.dart';
import '../bloc/event/approved_rides_event.dart';
import '../bloc/state/pending_rides_state.dart';
import 'widgets/pending_rides_card.dart';

class PendingRidesTab extends StatelessWidget {
  final String rideId;
  const PendingRidesTab({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PendingRidesBloc, PendingRidesState>(
      listener: (context, state) {
        if (state is RideApprovalSuccess) {
          // Refresh the approved rides list when a ride is approved
          context.read<ApprovedRidesBloc>().add(FetchApprovedRides(rideId));
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ride approved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is RideRejectedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ride rejected successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is PendingRidesError) {
          ErrorDialog.show(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is PendingRidesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PendingRidesError) {
          return Center(child: Text(state.message));
        } else if (state is PendingRidesLoaded) {
          if (state.rides.isEmpty) {
            return const Center(child: Text('No pending requests.'));
          }
          return ListView.builder(
            itemCount: state.rides.length,
            itemBuilder: (context, index) => PendingRideCard(
              ride: state.rides[index],
            ),
          );
        }
        return const Center(child: Text('Fetching pending requests...'));
      },
    );
  }
}
