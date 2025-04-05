import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/setting_button.dart';
import '../bloc/bloc/home_bloc.dart';
import '../bloc/role_bloc.dart';
import 'logout_dialog.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final theme = Theme.of(context);

    return BlocBuilder<RoleBloc, RoleState>(
      builder: (context, roleState) {
        return Drawer(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.r),
                bottomRight: Radius.circular(15.r),
              ),
            ),
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.r),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Colors.white,
                          size: 50.r,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          '${roleState.role} Menu',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
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
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.home,
                        title: 'Home',
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.directions_car,
                        title: 'My Cars',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/car');
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.notifications,
                        title: 'Notifications',
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Divider(thickness: 1),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: SettingButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      final homeBloc = context.read<HomeBloc>();
                      LogoutDialog().showLogoutDialog(context, homeBloc);
                    },
                    text: 'Logout',
                    color: Theme.of(context).primaryColor,
                  ),
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
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
        size: 24.r,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).primaryColorDark,
            ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).primaryColorDark,
        size: 16.r,
      ),
      onTap: onTap,
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      hoverColor: Theme.of(context).primaryColor.withOpacity(0.1),
    );
  }
}
