import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vroo_test/features/rider_journey/data/model/matching_rides_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/ride_journey_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/schedule_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/source_and_dest_model.dart';
import 'package:vroo_test/shared/widgets/booking_confirm_button.dart';

import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/zigzag.dart';
import '../../data/model/preferences_model.dart';
import '../bloc/bloc/booking_confirmation_bloc.dart';
import '../bloc/state/booking_confirmation_state.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String rideRequestId;
  final List<MatchingRideModel> matchingRides;
  final TimeOfDay minPickupTime;
  final TimeOfDay maxPickupTime;
  final ScheduleModel schedule;

  const BookingConfirmationScreen(
      {super.key,
      required this.rideRequestId,
      required this.matchingRides,
      required this.minPickupTime,
      required this.maxPickupTime,
      required this.schedule});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print('Ride Request ID: $rideRequestId');
    print('Matching Rides: $matchingRides');
    print('Min Pickup Time: ${minPickupTime.format(context)}');
    print('Max Pickup Time: ${maxPickupTime.format(context)}');
    return BlocListener<BookingConfirmationBloc, BookingConfirmationState>(
      listener: (context, state) {
        if (state is BookingConfirmationSuccess) {
          context.read<Navigation>().navigateTo('/matching_rides', arguments: {
            'rideRequestId': rideRequestId,
            'matchingRides': matchingRides,
            'minPickupTime': minPickupTime,
            'maxPickupTime': maxPickupTime,
            'schedule': schedule,
          });
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ZigZagIconWidget(),
              SizedBox(height: 20.h),
              Text(
                "Ride Created",
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.primaryColorDark,
                ),
              ),
              SizedBox(height: 30.h),
              BookingConfirmButton(
                text: 'Find a Ride',
                onTap: () {
                  context
                      .read<Navigation>()
                      .navigateTo('/matching_rides', arguments: {
                    'rideRequestId': rideRequestId,
                    'matchingRides': matchingRides,
                    'minPickupTime': minPickupTime,
                    'maxPickupTime': maxPickupTime,
                    'schedule': schedule,
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
