import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../core/utils/exit_dialouge_util.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../shared/widgets/gradient_button.dart';
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
    // final textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await DialogUtil.showExitDialog(context);
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
                          // SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                    // Gradient button to see all reviews
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GradientButton(
                        text: 'See All Reviews',
                        onTap: () {
                          context.read<Navigation>().navigateTo('/review');
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is UserProfileError) {
              print('Error: ${state.message}');
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
            }
            return const SizedBox();
          },
        ),
        bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
      ),
    );
  }
}
