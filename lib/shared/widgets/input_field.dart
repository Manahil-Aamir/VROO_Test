import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? errorText;
  final IconData? icon;
  final VoidCallback? onIconTap; // Function to be applied on icon tap

  const InputField({
    super.key,
    required this.labelText,
    required this.controller,
    this.readOnly = false,
    this.onTap,
    this.errorText,
    this.icon,
    this.onIconTap, // Optional function for icon tap
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(color: Theme.of(context).primaryColorDark),
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        errorStyle: TextStyle(color: Theme.of(context).indicatorColor),
        suffixIcon: icon != null
            ? GestureDetector(
                onTap: onIconTap,
                child: Icon(icon, color: Theme.of(context).primaryColor),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColorDark,
            width: 2.0.w,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          borderSide: BorderSide(
            color: Theme.of(context).indicatorColor,
            width: 2.0.w,
          ),
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColorLight,
        ),
        focusColor: Theme.of(context).primaryColorLight,
      ),
    );
  }
}
