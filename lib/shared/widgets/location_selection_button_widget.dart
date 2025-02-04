import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/navigation.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../core/theme/font/font_theme.dart';
import '../../core/router/routes.dart';
import '../../features/driver_booking/presentation/bloc/bloc/driver_home_bloc.dart';
import '../../features/driver_booking/presentation/bloc/event/driver_home_event.dart';

class LocationSelectionButtonsWidget extends StatelessWidget {
  const LocationSelectionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 120.h,
      left: 20.w,
      right: 20.w,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: ThemeColors.primaryColor, width: 2.w),
        ),
        padding: EdgeInsets.all(10.r),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
              // context.read<DriverHomeBloc>().add(ClearSharedPreferencesEvent());
                context
                    .read<Navigation>()
                    .navigateTo(Routes.locationSelection, arguments: 'driver');
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: ThemeColors.primaryColorDark,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: ThemeColors.scaffoldBackgroundColor),
                    SizedBox(width: 10.w),
                    Text('Starting Point',
                        style: AppFonts.bodyTextStyle.copyWith(
                            fontSize: AppFonts.body1TextSize.sp,
                            fontWeight: FontWeight.w500,
                            color: ThemeColors.scaffoldBackgroundColor)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () {
                // Trigger the event to clear SharedPreferences
                // context.read<DriverHomeBloc>().add(ClearSharedPreferencesEvent());
                context
                    .read<Navigation>()
                    .navigateTo(Routes.locationSelection, arguments: 'driver');
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: ThemeColors.primaryColorDark,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: ThemeColors.scaffoldBackgroundColor),
                    SizedBox(width: 10.w),
                    Text('Destination',
                        style: AppFonts.bodyTextStyle.copyWith(
                            fontSize: AppFonts.body1TextSize.sp,
                            fontWeight: FontWeight.w500,
                            color: ThemeColors.scaffoldBackgroundColor)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
