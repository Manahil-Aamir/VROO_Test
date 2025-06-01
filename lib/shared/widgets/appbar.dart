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
      preferredSize: Size.fromHeight(40.h),
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
                  theme.primaryColor.withOpacity(0.8),
                  theme.primaryColor.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Stack(
                  children: [
                    // Back button positioned on the left
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: theme.primaryColorDark,
                          size: 20.r,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // Perfectly centered heading
                    Positioned.fill(
                      child: Center(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Calculate available width excluding back button area
                            double availableWidth = constraints.maxWidth - 40.w;
                            print('Available width: $availableWidth');
                            double fontSize =
                                _calculateFontSize(heading, availableWidth);
                            print('Font size: $fontSize');
                            return SizedBox(
                              width: availableWidth,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  heading,
                                  style:
                                      theme.textTheme.headlineLarge?.copyWith(
                                    color: theme.primaryColorDark,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.25),
                                        offset: const Offset(0, 1),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                            );
                          },
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
  Size get preferredSize => Size.fromHeight(105.h);

  double _calculateFontSize(String text, double availableWidth) {
    int length = text.length;
    double fontSize;
    if (length <= 8) {
      fontSize = 28.sp;
    } else if (length <= 15) {
      fontSize = 25.sp;
    } else if (length <= 25) {
      fontSize = 21.sp;
    } else {
      fontSize = 18.sp;
    }
    print('Calculated font size for "$text" (length $length): $fontSize');
    return fontSize;
  }
}
