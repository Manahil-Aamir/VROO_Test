import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      appBar: appBar(heading: 'Join Requests'),
      body: BlocBuilder<RideRequestJoinBloc, RideRequestJoinState>(
        builder: (context, state) {
          if (state is RideRequestJoinLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RideRequestJoinLoaded) {
            if (state.joins.isEmpty) {
              return const Center(child: Text('No pending join requests'));
            }
            return ListView.builder(
              itemCount: state.joins.length + 1,
              itemBuilder: (context, index) {
                if (index < state.joins.length) {
                  final join = state.joins[index];
                  return PendingJoinCard(joinRequest: join);
                } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Need to find more matches?',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 5.w),
                      GestureDetector(
                        onTap: () {
                          // TODO: Add your functionality here
                          print('Find more drivers clicked');
                        },
                        child: Text(
                          'Find drivers',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor, 
                            decorationColor: Theme.of(context).primaryColor, 
                            decorationThickness: 2.w
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  );
                }
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

