import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/setting_button.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/initials_circle_avatar.dart';
import '../bloc/bloc/home_bloc.dart';
import '../bloc/role_bloc.dart';
import 'logout_dialog.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme for consistent styling
    final theme = Theme.of(context);

    return BlocBuilder<RoleBloc, RoleState>(
      builder: (context, roleState) {
        return Drawer(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.r),
              bottomRight: Radius.circular(15.r),
            ),
          ),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InitialsCircleAvatar(
                          initials: "HR", 
                          radius: 40.r,
                          textScaleFactor: 0.8,
                          showCameraIcon: false,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          roleState.role,
                          style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.scaffoldBackgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.home,
                        title: 'Home',
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Divider(
                        thickness: 1,
                        height: 8.h,
                        color: theme.primaryColorLight,
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.directions_car,
                        title: 'Cars',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/car');
                        },
                      ),
                      Divider(
                        thickness: 1,
                        height: 8.h,
                        color: theme.primaryColorLight,
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.contact_phone,
                        title: 'Emergency Contacts',
                        onTap: () {
                          Navigator.of(context).pop();
                          context
                              .read<Navigation>()
                              .navigateTo('/emergency_contacts');
                        },
                      ),
                      Divider(
                        thickness: 1,
                        height: 8.h,
                        color: theme.primaryColorLight,
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/settings');
                        },
                      ),
                      Divider(
                        thickness: 1,
                        height: 8.h,
                        color: theme.primaryColorLight,
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.logout,
                        title: 'Logout',
                        onTap: () {
                          Navigator.of(context).pop();
                          final homeBloc = context.read<HomeBloc>();
                          LogoutDialog().showLogoutDialog(context, homeBloc);
                        },
                      ),
                      Divider(
                        thickness: 1,
                        height: 8.h,
                        color: theme.primaryColorLight,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                SettingButton(
                  onTap: () {
                    context.read<Navigation>().navigateTo('/sos');
                  },
                  text: 'SOS',
                  color: theme.indicatorColor,
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: title == 'Logout'
            ? theme.indicatorColor
            : theme.primaryColorDark,
        size: 24.r,
      ),
      title: Text(
        title,
        style: title == 'Logout'
            ? theme.textTheme.bodyLarge?.copyWith(
                  color: theme.indicatorColor,
                )
            : theme.textTheme.bodyMedium?.copyWith(
                  color: theme.primaryColorDark,
                ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: title == 'Logout'
            ? theme.indicatorColor
            : theme.primaryColor,
        size: 16.r,
      ),
      onTap: onTap,
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      hoverColor: theme.primaryColor.withOpacity(0.1),
    );
  }
}
