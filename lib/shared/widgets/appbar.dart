import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bottom_shape_clipper.dart';

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
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 10.h, // Reduced top padding to move content upward
                  bottom: 0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align to top
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.topLeft,
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
                    SizedBox(width: 40.w),
                    // Heading
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        heading,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: theme.primaryColorDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
  Size get preferredSize => Size.fromHeight(90.h); // Responsive height
}
