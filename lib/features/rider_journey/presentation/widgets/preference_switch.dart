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
    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.primaryColorDark,
          ),
        ),
        SizedBox(width: 50.w),
        Switch(
          inactiveThumbColor: theme.scaffoldBackgroundColor,
          inactiveTrackColor: theme.primaryColorDark,
          activeColor: theme.primaryColor,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
