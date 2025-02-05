import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../bloc/bloc/rides_details_bloc.dart';
import '../bloc/event/rides_details_event.dart';
import '../bloc/state/rides_details_state.dart';
import 'widgets/rides_details_card.dart';

class RideDetailsScreen extends StatefulWidget {
  final String id;
  const RideDetailsScreen({super.key, required this.id});

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RideDetailsBloc>().add(FetchRideDetails(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(heading: 'Your Rides'),
      body: BlocBuilder<RideDetailsBloc, RideDetailsState>(
        builder: (context, state) {
          if (state is RideDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RideDetailsError) {
            return Center(child: Text(state.message));
          } else if (state is RideDetailsLoaded) {
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
