import 'package:flutter/material.dart';
import '../../../../../../core/theme/color/color_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final List<Widget> details;

  const DetailCard({super.key, required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0.r),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 13.w, 10.w, 10.w), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ThemeColors.captionTextColor,
                    fontSize: 16.sp, 
                  ),
            ),
            SizedBox(height: 8.h),
            Column(children: details),
          ],
        ),
      ),
    );
  }
}
