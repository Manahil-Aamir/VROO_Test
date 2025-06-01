import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bottom_shape_clipper.dart';

class appBar extends StatelessWidget implements PreferredSizeWidget {
  final String heading;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;

  const appBar({
    super.key,
    required this.heading,
    this.actionIcon,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(105.h),
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
                  theme.primaryColor.withOpacity(0.7),
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
                          color: theme.primaryColorDark,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconSize: 30.r,
                      ),
                    ),
                    // Spacer to push the heading to the center
                    SizedBox(width: 60.w),
                    // Heading
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        heading,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: theme.primaryColorDark,
                        ),
                      ),
                    ),
                    // Spacer to keep the heading centered
                    Spacer(),
                    // Optional action icon
                    if (actionIcon != null)
                      IconButton(
                        icon: Icon(
                          actionIcon,
                          color: theme.primaryColorDark,
                        ),
                        onPressed: onActionPressed,
                        iconSize: 30.r,
                      ),
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
  Size get preferredSize => Size.fromHeight(90.h); // Responsive height
}