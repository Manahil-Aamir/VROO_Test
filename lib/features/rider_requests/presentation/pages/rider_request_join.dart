import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/Appbar.dart';
import '../bloc/bloc/ride_request_join_bloc.dart';
import '../bloc/events/ride_request_join_event.dart';
import '../bloc/states/ride_request_join_state.dart';
import '../widget/pending_request_join_card.dart';

class RiderRequestJoinsPage extends StatefulWidget {
  final String rideRequestId;

  const RiderRequestJoinsPage({Key? key, required this.rideRequestId}) : super(key: key);

  @override
  State<RiderRequestJoinsPage> createState() => _RiderRequestJoinsPageState();
}

class _RiderRequestJoinsPageState extends State<RiderRequestJoinsPage> {
  @override
  void initState() {
    super.initState();
    print('request id: ${widget.rideRequestId}');
    // Dispatch the fetch event immediately when page opens
    context.read<RideRequestJoinBloc>().add(
      FetchPendingRideRequestJoins(widget.rideRequestId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(heading: 'Pending Joins'),
      body: BlocBuilder<RideRequestJoinBloc, RideRequestJoinState>(
        builder: (context, state) {
          if (state is RideRequestJoinLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RideRequestJoinLoaded) {
            if (state.joins.isEmpty) {
              return const Center(child: Text('No pending join requests'));
            }
            return ListView.builder(
              itemCount: state.joins.length,
              itemBuilder: (context, index) {
                final join = state.joins[index];
                return PendingJoinCard(joinRequest: join);
              },
            );
          } else if (state is RideRequestJoinError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

