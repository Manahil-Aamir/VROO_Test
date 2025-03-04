import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../core/theme/font/font_theme.dart';
import '../bloc/role_bloc.dart';

class TopBarWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const TopBarWidget({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleBloc, RoleState>(
      builder: (context, state) {
        return Positioned(
          top: 40.h,
          left: 20.w,
          right: 20.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMenuButton(context),
              _buildRoleSwitchButton(context, state.role),
              _buildNotificationButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.primaryColorDark,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: IconButton(
        icon: Icon(Icons.menu, color: ThemeColors.scaffoldBackgroundColor),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
    );
  }

  Widget _buildRoleSwitchButton(BuildContext context, String role) {
    return GestureDetector(
      onTap: () => _showRoleSwitchDialog(context, role),
      child: Container(
        width: 150.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: ThemeColors.primaryColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            role,
            style: AppFonts.headlineTextStyle.copyWith(
              color: ThemeColors.scaffoldBackgroundColor,
              fontStyle: FontStyle.italic,
              fontSize: AppFonts.headline2TextSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.primaryColorDark,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: IconButton(
        icon: const Icon(Icons.notifications, color: Colors.white),
        onPressed: () {},
      ),
    );
  }

  void _showRoleSwitchDialog(BuildContext context, String currentRole) {
    final roleBloc = BlocProvider.of<RoleBloc>(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Switch Role',
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Do you want to switch role?',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'No',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  roleBloc.add(SwitchRoleEvent());
                  // context.read<RoleBloc>().add(SwitchRoleEvent());
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}