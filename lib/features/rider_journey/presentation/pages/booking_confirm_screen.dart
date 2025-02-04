import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vroo_test/features/rider_journey/dependancy_injection/booking_confirm_di.dart';
import 'package:vroo_test/shared/widgets/booking_confirm_button.dart';

import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/zigzag.dart';
import '../bloc/bloc/booking_confirmation_bloc.dart';
import '../bloc/state/booking_confirmation_state.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String rideRequestId;
  final List<dynamic> matchingRides;
  final TimeOfDay minPickupTime;
  final TimeOfDay maxPickupTime;

  const BookingConfirmationScreen({
    super.key,
    required this.rideRequestId,
    required this.matchingRides,
    required this.minPickupTime,
    required this.maxPickupTime,
  });

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
          context
              .read<Navigation>()
              .navigateTo('/location_selection', arguments: {
            'role': 'rider',
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
                "Booking Confirmed",
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
                      .navigateTo('/location_selection', arguments: {
                    'role': 'rider',
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
