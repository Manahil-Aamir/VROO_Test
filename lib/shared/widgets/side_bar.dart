import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/features/rider_journey/presentation/bloc/bloc/rider_home_bloc.dart';
import 'package:vroo_test/shared/widgets/logout_dialog.dart';
import 'package:vroo_test/shared/widgets/setting_button.dart';
import '../../features/rider_journey/presentation/bloc/event/rider_home_event.dart';
import 'gradient_button.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                'Menu',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          SettingButton(
            onTap: () {
              Navigator.of(context).pop();
              final bloc = context.read<RiderHomeBloc>();
              LogoutDialog().showLogoutDialog(context, bloc);
            },
            text: 'Logout',
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
