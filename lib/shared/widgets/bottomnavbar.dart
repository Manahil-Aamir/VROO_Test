import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/font/font_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).unselectedWidgetColor,
      showUnselectedLabels: true,
      iconSize: 24.sp,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: AppFonts.bodyTextStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: AppFonts.body3TextSize,
      ),
      unselectedLabelStyle: AppFonts.bodyTextStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: AppFonts.body3TextSize,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.request_page),
          label: 'Request',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
