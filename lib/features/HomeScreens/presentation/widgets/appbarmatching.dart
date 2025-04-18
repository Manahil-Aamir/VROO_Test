import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/bottom_shape_clipper.dart';
import '../../../../shared/widgets/custom_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class appBarMatching extends StatelessWidget implements PreferredSizeWidget {
  final String heading;

  const appBarMatching({
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back button - left aligned
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
                    // Heading - centered
                    Center(
                      child: Text(
                        heading,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: theme.primaryColorDark,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Home button - right aligned
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.home,
                          color: theme.primaryColorDark,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => CustomDialog(
                              title: 'Go to Home',
                              message:
                                  'Are you sure you want to go back to home?',
                              confirmText: 'Yes',
                              cancelText: 'Cancel',
                              confirmColor: theme.indicatorColor,
                              cancelColor: theme.primaryColorDark,
                              onConfirm: () {
                                context.read<Navigation>().navigateTo('/home');
                              },
                              onCancel: () {
                                Navigator.pop(dialogContext);
                              },
                            ),
                          );
                        },
                        iconSize: 30.r,
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
  Size get preferredSize => Size.fromHeight(105.h); // Responsive height
}
