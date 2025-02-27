import 'package:flutter/material.dart';
import '../../features/driver_booking/presentation/bloc/bloc/driver_home_bloc.dart';
import '../../features/driver_booking/presentation/bloc/event/driver_home_event.dart';
import '../../features/rider_journey/presentation/bloc/bloc/rider_home_bloc.dart';
import '../../features/rider_journey/presentation/bloc/event/rider_home_event.dart';

class LogoutDialog {
  void showLogoutDialog(BuildContext context, dynamic homeBloc) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: theme.textTheme.displayLarge?.copyWith(
              color: theme.primaryColorDark,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.primaryColorDark,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog first

                // Now use the passed bloc instead of context.read()
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (homeBloc is RiderHomeBloc) {
                    homeBloc.add(RiderLogoutEvent()); // Safe Bloc call
                  } else if (homeBloc is DriverHomeBloc) {
                    homeBloc.add(DriverLogoutEvent()); // Safe Bloc call
                  }
                });
              },
              child: Text(
                'Logout',
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
