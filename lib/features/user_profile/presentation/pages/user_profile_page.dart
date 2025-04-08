import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../shared/widgets/custom_dialog.dart';
import '../bloc/bloc/user_profile_bloc.dart';
import '../bloc/event/user_profile_event.dart';
import '../bloc/state/user_profile_state.dart';
import '../widgets/environmental_impact.dart';
import '../widgets/profile_header.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_cards.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserProfileBloc>(context).add(LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await _showExitDialog(context);
        if (exitApp) {
          SystemNavigator.pop(); // Closes the app
        }
        return false; // Prevents the default back action
      },
      child: Scaffold(
        backgroundColor: ThemeColors.scaffoldBackgroundColor,
        body: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: ThemeColors.progressIndicatorColor,
                  strokeWidth: 3.w,
                ),
              );
            } else if (state is UserProfileLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with profile info
                    ProfileHeader(user: state.userProfile),

                    // Stats sections
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),
                          StatCards(user: state.userProfile),
                          SizedBox(height: 24.h),
                          SectionTitle(title: 'Environmental Impact'),
                          EnvironmentalImpact(user: state.userProfile),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is UserProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 60.w, color: ThemeColors.accentColor),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        state.message,
                        style: textTheme.bodyMedium?.copyWith(
                          color: ThemeColors.accentColor,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<UserProfileBloc>(context)
                            .add(LoadUserProfile());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.buttonColor,
                        foregroundColor: ThemeColors.buttonTextColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text(
                        'Try Again',
                        style: textTheme.labelLarge?.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox();
          },
        ),
        bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => CustomDialog(
            title: "Exit App",
            message: "Are you sure you want to exit?",
            confirmText: "Yes",
            cancelText: "No",
            confirmColor: Theme.of(context).indicatorColor,
            cancelColor: Theme.of(context).primaryColorDark,
            onConfirm: () {
              Navigator.of(context).pop(true);
            },
            onCancel: () {
              Navigator.of(context).pop(false);
            },
          ),
        ) ??
        false;
  }
}
