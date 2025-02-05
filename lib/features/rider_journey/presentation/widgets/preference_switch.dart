import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreferenceSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const PreferenceSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.scaffoldBackgroundColor,
      shadowColor: theme.primaryColorLight,
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Row(
          children: [
            Text(
              label,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.primaryColorDark,
              ),
            ),
            Spacer(),
            Switch(
              inactiveThumbColor: theme.scaffoldBackgroundColor,
              inactiveTrackColor: theme.primaryColorDark,
              activeColor: theme.primaryColor,
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
