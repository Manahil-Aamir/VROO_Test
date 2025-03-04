import 'package:flutter/material.dart';
import '../bloc/bloc/home_bloc.dart';
import '../bloc/event/home_event.dart';

class LogoutDialog {
  void showLogoutDialog(BuildContext context, HomeBloc homeBloc) {
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
                Navigator.of(dialogContext).pop();
                // Use unified logout event
                homeBloc.add(LogoutEvent());
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