import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/color/color_theme.dart';
import 'bottom_ship_clipper.dart';

class appBar extends StatelessWidget implements PreferredSizeWidget {
  final String heading;

  const appBar({
    super.key,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(120.h),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: ClipPath(
          clipper: BottomShapeClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: ThemeColors.buttonTextColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconSize: 30.r,
                      ),
                    ),
                    // Spacer to push the heading to the center
                    SizedBox(width: 50.w),
                    // Heading
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        heading,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: theme.scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                    // Spacer to keep the heading centered
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120.h); // Responsive height
}
