import 'package:flutter/material.dart';
import '../../../../../../core/theme/color/color_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableDetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ExpandableDetailTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: InkWell(
        onTap: () => _showDetailBottomSheet(context),
        child: Row(
          children: [
            Icon(icon, color: ThemeColors.primaryColor, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
            child: Text(label,
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: theme.primaryColorDark)),
            ),
            Expanded(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: theme.primaryColorDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}