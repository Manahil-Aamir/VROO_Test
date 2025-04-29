import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc/rider_pending_requests_bloc.dart';
import '../bloc/states/rider_pending_requests_state.dart';
import '../widget/rider_pending_card.dart';

class RiderPendingTab extends StatelessWidget {
  const RiderPendingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RiderPendingRequestBloc, RiderPendingRequestState>(
      listener: (context, state) {
        if (state is RiderPendingRequestDeleted) {
          // Show success message or snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Request deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is RiderPendingRequestLoading && 
            !(state is RiderPendingRequestLoaded)) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RiderPendingRequestError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/error.png'),
                Text(state.message),
              ],
            ),
          );
        } else if (state is RiderPendingRequestLoaded || 
                  state is RiderPendingRequestDeleted) {
          final requests = state is RiderPendingRequestLoaded 
              ? state.requests 
              : (state as RiderPendingRequestDeleted).remainingRequests;
          
          if (requests.isEmpty) {
            return const Center(child: Text('No pending requests found'));
          }
          
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) => PendingRequestCard(
              request: requests[index],
            ),
          );
        }
        return const Center(child: Text('Select tab to load requests'));
      },
    );
  }
}
