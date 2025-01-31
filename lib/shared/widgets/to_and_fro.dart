import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToAndFroWidget extends StatelessWidget {
  final String fromDescription;
  final String toDescription;

  const ToAndFroWidget({
    super.key,
    required this.fromDescription,
    required this.toDescription,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryColor, width: 2.0.w),
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.primaryColorDark,
                      borderRadius: BorderRadius.circular(8.0.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: theme.primaryColor),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            fromDescription,
                            style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.scaffoldBackgroundColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Center(
                      child: Icon(
                    Icons.arrow_downward,
                    color: theme.primaryColor,
                    size: 25.0.r,
                  )),
                  SizedBox(height: 4.h),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.primaryColorDark,
                      borderRadius: BorderRadius.circular(8.0.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: theme.primaryColorLight),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            toDescription,
                            style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.scaffoldBackgroundColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
