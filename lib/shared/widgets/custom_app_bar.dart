import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bottom_shape_clipper.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int highlightedCircles;
  final int totalCircles = 3;

  const CustomAppBar({
    super.key,
    this.highlightedCircles = 0, // Default highlighted circles
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: const Size.fromHeight(120.0),
      child: ClipPath(
        clipper: BottomShapeClipper(),
        child: Container(
          height: 420.h,
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
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Theme.of(context).primaryColorDark, size: 30.r),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Circles and separators
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(totalCircles, (index) {
                        return Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColorDark, // Background color of the border
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context)
                                      .primaryColorDark, // Border color
                                  width: 3.0.w, // Border width
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 18.r,
                                backgroundColor: index < highlightedCircles
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).canvasColor,
                              ),
                            ),
                            if (index < totalCircles - 1)
                              Container(
                                width: 20.w,
                                height: 5.h,
                                color: theme.primaryColorDark,
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                  // Home button
                  IconButton(
                    icon: Icon(Icons.home,
                        color: theme.primaryColorDark, size: 30.r),
                    onPressed: () {
                      // Navigate to home or perform other actions
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120.0.h);
}
