import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/Appbar.dart';
import '../../../matching/presentation/bloc/bloc/matching_bloc.dart';
import '../../../matching/presentation/bloc/event/matching_event.dart';
import '../../../matching/presentation/bloc/state/matching_state.dart';
import '../../../matching/presentation/widgets/match_card.dart';
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
    context.read<RideRequestJoinBloc>().add(
      FetchPendingRideRequestJoins(widget.rideRequestId),
    );
  }

  void _fetchMatches(BuildContext context) {
    final bloc = context.read<MatchingBloc>();
    print('Before adding FetchRideRequestMatchesEvent');
    
    bloc.add(FetchRideRequestMatchesEvent(rideRequestId: widget.rideRequestId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(heading: 'Join Requests'),
      body: MultiBlocListener(
        listeners: [
          BlocListener<RideRequestJoinBloc, RideRequestJoinState>(
            listener: (context, state) {
              if (state is RideRequestJoinError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
          BlocListener<MatchingBloc, MatchingState>(
            listener: (context, state) {
              if (state is RiderRequestError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<RideRequestJoinBloc, RideRequestJoinState>(
          builder: (context, joinState) {
            return BlocBuilder<MatchingBloc, MatchingState>(
              builder: (context, matchState) {
                if (joinState is RideRequestJoinLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (joinState is RideRequestJoinLoaded) {
                  return ListView(
                    children: [
                      // Existing join requests
                      if (joinState.joins.isNotEmpty)
                        ...joinState.joins.map((join) => PendingJoinCard(joinRequest: join)).toList(),
                      if (joinState.joins.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: Text('No pending join requests')),
                        ),

                      // Find more drivers button
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _fetchMatches(context),
                              child: Text(
                                'Find more drivers',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      color: Theme.of(context).primaryColor, 
                                      decorationColor: Theme.of(context).primaryColor, 
                                      decorationThickness: 2.w,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Matches section
                      if (matchState is MatchesLoading)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      
                      if (matchState is MatchesVisibilityToggled && matchState.showMatches)
                        _buildMatchesSection(context, matchState),
                      
                      if (matchState is RideRequestMatchesLoaded)
                        _buildMatchesSection(context, matchState),
                    ],
                  );
                }

                if (joinState is RideRequestJoinError) {
                  return Center(child: Text('Error: ${joinState.message}'));
                }

                return const SizedBox();
              },
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildMatchesSection(BuildContext context, dynamic state) {
    final matches = state is MatchesVisibilityToggled 
        ? state.matches 
        : (state as RideRequestMatchesLoaded).matches;

    return Column(
      children: [
        ...matches.map((match) => RideMatchCard(match: match)).toList(),
      ],
    );
  }
}
