import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../core/theme/font/font_theme.dart';
import '../../core/router/navigation.dart'; // Ensure this is imported

class TopBarDriverWidget extends StatelessWidget {
  final String roleText;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const TopBarDriverWidget(
      {super.key, required this.roleText, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40.h,
      left: 20.w,
      right: 20.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.primaryColorDark,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              icon:
                  Icon(Icons.menu, color: ThemeColors.scaffoldBackgroundColor),
              onPressed: () {
                print('open');
                scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Switch Role',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          ),
                    ),
                    content: Text(
                      'Do you want to switch role?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (roleText == 'Driver') {
                                context
                                    .read<Navigation>()
                                    .navigateTo('/riderhome');
                              } else {
                                context
                                    .read<Navigation>()
                                    .navigateTo('/driver_home');
                              }
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              width: 150.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: ThemeColors.primaryColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  roleText,
                  style: AppFonts.headlineTextStyle.copyWith(
                      color: ThemeColors.scaffoldBackgroundColor,
                      fontStyle: FontStyle.italic,
                      fontSize: AppFonts.headline2TextSize,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.primaryColorDark,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                // Handle notification action
              },
            ),
          ),
        ],
      ),
    );
  }
}
