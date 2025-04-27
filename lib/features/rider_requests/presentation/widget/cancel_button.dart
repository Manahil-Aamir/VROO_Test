// lib/shared/widgets/cancel_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/dialog_button.dart';

class CancelButton extends StatelessWidget {
  final VoidCallback onCancel;

  const CancelButton({
    Key? key,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 33.h,
      child: DialogButton(
        onTap: onCancel,
        text: 'Cancel',
        color: ThemeColors.accentColor,
      ),
    );
  }
}
