import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/color/color_theme.dart';

class ErrorDialog extends StatelessWidget {
  final String errorMessage;

  const ErrorDialog({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeColors.backgroundColor,
      contentPadding: EdgeInsets.fromLTRB(24.w, 15.h, 24.w, 24.h),
      titlePadding: EdgeInsets.all(16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.r),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: ThemeColors.accentColor),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Submission Failed',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ThemeColors.headlinesTextColor,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: ThemeColors.primaryColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Please try again...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.bodyTextColor,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            errorMessage,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.bodyTextColor,
                ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  /// Function to show the dialog
  static void show(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(errorMessage: errorMessage),
    );
  }
}
