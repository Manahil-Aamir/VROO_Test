import 'package:flutter/material.dart';
import '../../../../shared/widgets/dialog_button.dart';
import '../bloc/bloc/home_bloc.dart';
import '../bloc/event/home_event.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutDialog {
  void showLogoutDialog(BuildContext context, HomeBloc homeBloc) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Logout',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColorDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Are you sure you want to logout?',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.primaryColorDark,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DialogButton(
                      text: 'Cancel',
                      color: theme.primaryColorDark,
                      onTap: () => Navigator.of(dialogContext).pop(),
                    ),
                    DialogButton(
                      text: 'Logout',
                      color: theme.indicatorColor,
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        homeBloc.add(LogoutEvent());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
