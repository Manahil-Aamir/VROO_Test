import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/setting_button.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/custom_dialog.dart';
import '../../../sos/data/data_source/tracking_data_source.dart';
import '../../../sos/presentation/bloc/bloc/sos_bloc.dart';
import '../../../sos/presentation/bloc/event/sos_event.dart';
import '../../../sos/presentation/bloc/state/sos_state.dart';
import '../../../../shared/widgets/initials_circle_avatar.dart';
import '../bloc/bloc/home_bloc.dart';
import '../bloc/role_bloc.dart';
import 'logout_dialog.dart';

class SidebarWidget extends StatefulWidget {
  const SidebarWidget({super.key});

  @override
  _SidebarWidgetState createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  bool isTracking = false;
  String _latestSessionId = '';

  void toggleTracking() {
    final theme = Theme.of(context);
    setState(() {
      isTracking = !isTracking;
    });

    print('tracking: $isTracking');

    if (isTracking) {
      final sosBloc = BlocProvider.of<SosBloc>(context);
      sosBloc.add(TriggerSos());
    } else {
      showDialog(
        context: context,
        builder: (dialogContext) => CustomDialog(
          title: "Stop Tracking",
          message: "Are you sure you want to stop tracking?",
          confirmColor: theme.indicatorColor,
          cancelColor: theme.primaryColorDark,
          confirmText: "Yes",
          cancelText: "No",
          onConfirm: () {
            Navigator.pop(dialogContext);
            SosTrackerService(sessionId: _latestSessionId).stopTracking();
          },
          onCancel: () {
            Navigator.pop(dialogContext);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<SosBloc, SosState>(
      listener: (context, state) {
        if (state is SosTriggered) {
          _latestSessionId = state.sessionId;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("SOS Triggered Successfully!"),
              backgroundColor: theme.secondaryHeaderColor,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is SosError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.indicatorColor,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: BlocBuilder<RoleBloc, RoleState>(
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
                    curve: Curves.easeInQuart,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.r),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
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
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      children: [
                        _buildMenuItem(
                          context,
                          icon: Icons.home,
                          title: 'Home',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        Divider(thickness: 1, color: theme.primaryColorLight),
                        _buildMenuItem(
                          context,
                          icon: Icons.directions_car,
                          title: 'Cars',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed('/car');
                          },
                        ),
                        Divider(thickness: 1, color: theme.primaryColorLight),
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
                        Divider(thickness: 1, color: theme.primaryColorLight),
                        _buildMenuItem(
                          context,
                          icon: Icons.settings,
                          title: 'Settings',
                          onTap: () {
                            Navigator.of(context).pop();
                            final homeBloc = context.read<HomeBloc>();
                            LogoutDialog().showLogoutDialog(context, homeBloc);
                          },
                        ),
                        Divider(thickness: 1, color: theme.primaryColorLight),
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
                        Divider(thickness: 1, color: theme.primaryColorLight),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 48.0),
                    child: SettingButton(
                      onTap: toggleTracking,
                      text: isTracking ? 'Stop Tracking' : 'SOS',
                      color: isTracking
                          ? theme.primaryColor
                          : theme.indicatorColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
