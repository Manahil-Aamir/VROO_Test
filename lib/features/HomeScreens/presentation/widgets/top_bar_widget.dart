import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../core/theme/font/font_theme.dart';
import '../../../../shared/widgets/dialog_button.dart';
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
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Switch Role',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColorDark,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                currentRole.toLowerCase() == 'driver'
                    ? 'Do you want to switch to Rider?'
                    : 'Do you want to switch to Driver?',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.primaryColorDark,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DialogButton(
                    text: 'No',
                    color: theme.primaryColorDark,
                    onTap: () => Navigator.pop(dialogContext),
                  ),
                  DialogButton(
                    text: 'Yes',
                    color: theme.primaryColor,
                    onTap: () {
                      Navigator.pop(dialogContext);
                      roleBloc.add(SwitchRoleEvent());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
