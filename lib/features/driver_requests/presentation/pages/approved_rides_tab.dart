import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          print('Loading approved rides...');
          return const Center(child: CircularProgressIndicator());
        } else if (state is ApprovedRidesError) {
          print('Error loading approved rides: ${state.message}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/error.png',
                    width: 300.w,
                    height: 300.h,
                    fit: BoxFit.contain,
                  ),            
                ],
              ),
            );
                    
        } else if (state is ApprovedRidesLoaded) {
          print('Approved rides loaded: ${state.rides.length} rides found.');
          if (state.rides.isEmpty) {
            print('No approved rides found.');
            return const Center(child: Text('No approved requests.'));
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
