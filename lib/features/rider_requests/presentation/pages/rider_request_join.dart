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

  const RiderRequestJoinsPage({super.key, required this.rideRequestId});

  @override
  State<RiderRequestJoinsPage> createState() => _RiderRequestJoinsPageState();
}

class _RiderRequestJoinsPageState extends State<RiderRequestJoinsPage> {
  @override
  void initState() {
    super.initState();
    _loadPendingJoins();
  }

  void _loadPendingJoins() {
    context.read<RideRequestJoinBloc>().add(
          FetchPendingRideRequestJoins(widget.rideRequestId),
        );
  }

  void _fetchMatches(BuildContext context) {
    final bloc = context.read<MatchingBloc>();
    bloc.add(FetchRideRequestMatchesEvent(rideRequestId: widget.rideRequestId));
  }

  void _showJoinSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Join request sent successfully!'),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(heading: 'Join Requests'),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MatchingBloc, MatchingState>(
            listener: (context, state) {
              if (state is RiderJoinSuccess) {
                _loadPendingJoins();
                _showJoinSuccessSnackBar(context);
              }
            },
          ),
        ],
        child: BlocBuilder<RideRequestJoinBloc, RideRequestJoinState>(
          builder: (context, joinState) {
            return BlocBuilder<MatchingBloc, MatchingState>(
              builder: (context, matchState) {
                return _buildMainContent(joinState, matchState, context);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(RideRequestJoinState joinState,
      MatchingState matchState, BuildContext context) {
    if (joinState is RideRequestJoinLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (joinState is RideRequestJoinError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/error.png',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              joinState.message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (joinState is RideRequestJoinLoaded) {
      return ListView(
        children: [
          if (joinState.joins.isNotEmpty)
            ...joinState.joins
                .map((join) => PendingJoinCard(joinRequest: join)),
          if (joinState.joins.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text('No join requests')),
            ),
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
          if (matchState is MatchesLoading)
            const Center(child: CircularProgressIndicator()),
          if (matchState is MatchesVisibilityToggled && matchState.showMatches)
            _buildMatchesSection(context, matchState),
          if (matchState is RideRequestMatchesLoaded)
            _buildMatchesSection(context, matchState),
          if ((matchState is RideRequestMatchesLoaded &&
                  matchState.matches.isEmpty) ||
              (matchState is MatchesVisibilityToggled &&
                  matchState.matches.isEmpty))
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No matches available right now,\n'
                  'please try again later',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (matchState is RiderRequestError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/error.png',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    matchState.error,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _buildMatchesSection(BuildContext context, dynamic state) {
    final matches = state is MatchesVisibilityToggled
        ? state.matches
        : (state as RideRequestMatchesLoaded).matches;

    return Column(
      children: [
        ...matches.map((match) => RideMatchCard(
              match: match,
              rideRequestId: widget.rideRequestId,
            )),
      ],
    );
  }
}
