import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/setting_button.dart';
import '../../../../core/router/navigation.dart';
import '../bloc/bloc/home_bloc.dart';
import '../bloc/role_bloc.dart';
import 'logout_dialog.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleBloc, RoleState>(
      builder: (context, roleState) {
        return Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    '${roleState.role} Menu',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              SettingButton(
                  onTap: () {
                    context.read<Navigation>().navigateTo('/sos');
                  },
                  text: 'SOS',
                  color: Theme.of(context).indicatorColor,
                  textColor: Theme.of(context).scaffoldBackgroundColor),
              SizedBox(
                height: 10.h,
              ),
              SettingButton(
                onTap: () {
                  Navigator.of(context).pop();
                  final homeBloc = context.read<HomeBloc>();
                  LogoutDialog().showLogoutDialog(context, homeBloc);
                },
                text: 'Logout',
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryColorDark,
              ),
            ],
          ),
        );
      },
    );
  }
}
