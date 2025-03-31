import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/error_dialog.dart';
import '../bloc/bloc/approved_rides_bloc.dart';
import '../bloc/state/approved_rides_state.dart';
import 'widgets/approved_rides_card.dart';

class ApprovedRidesTab extends StatelessWidget {
  final String rideId;
  const ApprovedRidesTab({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApprovedRidesBloc, ApprovedRidesState>(
      listener: (context, state) {
        if (state is ApprovedRidesError) {
          ErrorDialog.show(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ApprovedRidesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ApprovedRidesError) {
          return Center(child: Text(state.message));
        } else if (state is ApprovedRidesLoaded) {
          if (state.rides.isEmpty) {
            return const Center(child: Text('No pending requests.'));
          }
          return ListView.builder(
            itemCount: state.rides.length,
            itemBuilder: (context, index) => ApprovedRideCard(
              ride: state.rides[index],
            ),
          );
        }
        return const Center(child: Text('Fetching approved requests...'));
      },
    );
  }
}
