import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/dialog_button.dart';

class CancelButton extends StatelessWidget {
  final VoidCallback onCancel;

  const CancelButton({
    super.key,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8, // Scales down the entire button by 15%
      child: SizedBox(
        height: 33.h, // Reduced from 33.h
        child: DialogButton(
          onTap: onCancel,
          text: 'Cancel',
          color: ThemeColors.accentColor,
        ),
      ),
    );
  }
}
