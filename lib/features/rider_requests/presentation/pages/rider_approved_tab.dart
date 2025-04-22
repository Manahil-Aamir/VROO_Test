import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc/rider_approved_requests_bloc.dart';
import '../bloc/states/rider_approved_requests_state.dart';
import '../widget/rider_approved_card.dart';

class RiderApprovedTab extends StatelessWidget {
  const RiderApprovedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiderApprovedRequestBloc, RiderApprovedRequestState>(
      // listener: (context, state) {
      //   if (state is RiderApprovedRequestError) {
      //     ErrorDialog.show(context, state.message);
      //   }
      // },
      builder: (context, state) {
        if (state is RiderApprovedRequestLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RiderApprovedRequestError) {
          print('Error loading rider approved requests: ${state.message}');
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
              ],
            ),
          );
        } else if (state is RiderApprovedRequestLoaded) {
          if (state.requests.isEmpty) {
            return const Center(child: Text('No approved requests found'));
          }
          return ListView.builder(
            // padding: const EdgeInsets.all(16),
            itemCount: state.requests.length,
            itemBuilder: (context, index) => ApprovedRequestCard(
              request: state.requests[index],
            ),
          );
        }
        return const Center(child: Text('Select tab to load requests'));
      },
    );
  }
}
