import 'package:flutter/material.dart';
import '../../../../../../core/theme/color/color_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableDetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const ExpandableDetailTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: ThemeColors.primaryColor, size: 24.sp), 
            SizedBox(width: 12.w), 
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16.sp),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp), 
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}