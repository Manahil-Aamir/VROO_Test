import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderDropdown extends StatelessWidget {
  final String? selectedValue;
  final String? labelText;
  final String? errorText;
  final String? hintText;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const GenderDropdown({
    super.key,
    required this.selectedValue,
    required this.labelText,
    required this.errorText,
    required this.hintText,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      value: selectedValue,
      icon: Icon(
        Icons.arrow_drop_down,
        color: theme.primaryColor,
      ),
      dropdownColor: theme.canvasColor,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.primaryColorDark,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        hintText: hintText,
        hintStyle: TextStyle(
          color: theme.primaryColorLight,
        ),
        errorStyle: TextStyle(
          color: theme.indicatorColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          borderSide: BorderSide(
            color: theme.primaryColorDark,
            width: 2.0.w,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          borderSide: BorderSide(
            color: theme.indicatorColor,
            width: 2.0.w,
          ),
        ),
        labelStyle: TextStyle(
          color: theme.primaryColorLight,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.0.w,
          vertical: 14.0.h,
        ),
      ),
      onChanged: onChanged,
      items: items
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.primaryColorDark,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
