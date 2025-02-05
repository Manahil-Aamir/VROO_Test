import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/color/color_theme.dart';

class LoadingOverlay extends StatelessWidget {
  final bool visible;

  const LoadingOverlay({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.progressIndicatorColor),
            strokeWidth: 4.0.w, 
          ),
        ),
      ),
    );
  }
}
