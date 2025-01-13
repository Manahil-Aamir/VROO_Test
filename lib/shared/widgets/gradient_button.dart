import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const GradientButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColorDark,
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Theme.of(context).scaffoldBackgroundColor, // Text color
            ),
          ),
        ),
      ),
    );
  }
}
