import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc/rider_pending_requests_bloc.dart';
import '../bloc/states/rider_pending_requests_state.dart';
import '../widget/rider_pending_card.dart';

class RiderPendingTab extends StatelessWidget {
  const RiderPendingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiderPendingRequestBloc, RiderPendingRequestState>(
      // listener: (context, state) {
      //   if (state is RiderPendingRequestError) {
      //     ErrorDialog.show(context, state.message);
      //   }
      //   // Add any success listeners if needed
      // },
      builder: (context, state) {
        if (state is RiderPendingRequestLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RiderPendingRequestError) {
          print('Error loading rider pending requests: ${state.message}');
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
              ],
            ),
          );
        } else if (state is RiderPendingRequestLoaded) {
          if (state.requests.isEmpty) {
            return const Center(child: Text('No pending requests found'));
          }
          return ListView.builder(
            // padding: const EdgeInsets.all(16),
            itemCount: state.requests.length,
            itemBuilder: (context, index) => PendingRequestCard(
              request: state.requests[index],
            ),
          );
        }
        return const Center(child: Text('Select tab to load requests'));
      },
    );
  }
}
