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
          // Listen for successful join events and refresh the pending joins list
          BlocListener<MatchingBloc, MatchingState>(
            listener: (context, state) {
              if (state is RiderJoinSuccess) {
                // Refresh the pending joins list
                _loadPendingJoins();
                // Show success message
                _showJoinSuccessSnackBar(context);
              }
            },
          ),
        ],
        child: BlocBuilder<RideRequestJoinBloc, RideRequestJoinState>(
          builder: (context, joinState) {
            return BlocBuilder<MatchingBloc, MatchingState>(
              builder: (context, matchState) {
                // 🔵 Handle join request loading
                if (matchState is RiderJoinLoading) {
                  return Stack(
                    children: [
                      _buildMainContent(joinState, matchState, context),
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  );
                }
                
                return _buildMainContent(joinState, matchState, context);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(RideRequestJoinState joinState, MatchingState matchState, BuildContext context) {
    // 🔵 Handle loading
    if (joinState is RideRequestJoinLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 🔴 Handle error with an image
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

    // ✅ Handle loaded data
    if (joinState is RideRequestJoinLoaded) {
      return ListView(
        children: [
          // Existing pending join requests
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

          // Loading indicator while fetching matches
          if (matchState is MatchesLoading)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // Show Matches if loaded
          if (matchState is MatchesVisibilityToggled && matchState.showMatches)
            _buildMatchesSection(context, matchState),

          if (matchState is RideRequestMatchesLoaded)
            _buildMatchesSection(context, matchState),

          // 🔴 Also show error for MatchingBloc (if needed)
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
        )).toList(),
      ],
    );
  }
}
