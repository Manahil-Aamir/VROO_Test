import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bottom_shape_clipper.dart';

class AppBarNoIcon extends StatelessWidget implements PreferredSizeWidget {
  final String heading;
  final Widget? leading; // Added optional leading widget

  const AppBarNoIcon({
    super.key,
    required this.heading,
    this.leading,
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
                  theme.primaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Leading widget (if provided)
                    if (leading != null)
                      Positioned(
                        left: 0,
                        child: leading!,
                      ),
                    // Title
                    Center(
                      child: Text(
                        heading,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: theme.primaryColorDark,
                        ),
                      ),
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
  Size get preferredSize => Size.fromHeight(120.h); // Responsive height
}
