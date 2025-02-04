import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingConfirmButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const BookingConfirmButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        width: 250.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColorDark,
              theme.primaryColorDark.withOpacity(0.5),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.scaffoldBackgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
