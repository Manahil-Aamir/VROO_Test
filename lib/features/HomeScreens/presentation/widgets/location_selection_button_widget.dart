import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../core/theme/font/font_theme.dart';
import '../bloc/bloc/home_bloc.dart';
import '../bloc/event/home_event.dart';
import '../bloc/role_bloc.dart';

class LocationSelectionButtonsWidget extends StatelessWidget {
  const LocationSelectionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleBloc, RoleState>(
      builder: (context, roleState) {
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
                _buildLocationButton(
                  context: context,
                  label: 'Starting Point',
                  onTap: () => _handleLocationSelection(context, roleState.role),
                ),
                SizedBox(height: 10.h),
                _buildLocationButton(
                  context: context,
                  label: 'Destination',
                  onTap: () => _handleLocationSelection(context, roleState.role),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
            Text(
              label,
              style: AppFonts.bodyTextStyle.copyWith(
                fontSize: AppFonts.body1TextSize.sp,
                fontWeight: FontWeight.w500,
                color: ThemeColors.scaffoldBackgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLocationSelection(BuildContext context, String role) {
    // Clear preferences using HomeBloc
    context.read<HomeBloc>().add(ClearPreferencesEvent());
    
    // // Navigate to appropriate route based on role
    // final route = role == 'Driver' 
    //     ? '/location_selection_driver' 
    //     : '/location_selection';

    context.read<Navigation>().navigateTo('/location');
  }
}