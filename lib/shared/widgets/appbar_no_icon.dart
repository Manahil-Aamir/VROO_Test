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
                  top: 10.h, // Move content further upward by reducing top padding
                  bottom: 0,
                ),
                child: Row(
                  children: [
                    // Leading widget (fixed width container)
                    SizedBox(
                      width: leading != null ? 46.w : 0, // Fixed width when leading exists
                      child: leading != null 
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: leading!,
                            )
                          : null,
                    ),
                    // Centered heading with flexible space
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Center(
                          child: Text(
                            heading,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: theme.primaryColorDark,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2, // Allow up to 2 lines for long headings
                          ),
                        ),
                      ),
                    ),
                    // Right spacer to balance the layout
                    SizedBox(
                      width: leading != null ? 46.w : 0, // Match left side width
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
  Size get preferredSize => Size.fromHeight(105.h); // Match the PreferredSize height
}
