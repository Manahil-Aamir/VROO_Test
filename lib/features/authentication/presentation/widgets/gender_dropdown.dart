import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/core/theme/color/color_theme.dart';
import 'package:vroo_test/features/authentication/presentation/widgets/form_field_container.dart';

class GenderDropdown extends StatelessWidget {
  final String? selectedValue;
  final String labelText;
  final String? errorText;
  final String? hintText;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final bool isDisabled;
  final bool showCustomInputWhenOther;

  const GenderDropdown({
    super.key,
    required this.selectedValue,
    required this.labelText,
    this.errorText,
    this.hintText,
    required this.items,
    required this.onChanged,
    this.isDisabled = false,
    this.showCustomInputWhenOther = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isOtherSelected =
        selectedValue == 'Other' && showCustomInputWhenOther;

    return FormFieldContainer(
      labelText: labelText,
      errorText: errorText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: isDisabled
                    ? ThemeColors.dividerColor.withOpacity(0.5)
                    : (errorText != null
                        ? ThemeColors.accentColor
                        : ThemeColors.primaryColorLight),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Material(
                color: Colors.transparent,
                child: PopupMenuButton<String>(
                  enabled: !isDisabled,
                  initialValue: selectedValue,
                  onSelected: (value) {
                    onChanged?.call(value);
                  },
                  itemBuilder: (context) => items.map((item) {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  offset: Offset(0, 40.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: ThemeColors.cardColor,
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 32.w,
                    maxWidth: MediaQuery.of(context).size.width - 32.w,
                    maxHeight: 250.h,
                  ),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedValue ?? (hintText ?? 'Select $labelText'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: selectedValue == null
                                ? ThemeColors.primaryColorLight
                                : ThemeColors.primaryColorDark,
                          ),
                        ),
                        Row(
                          children: [
                            if (items.length > 5)
                              Icon(
                                Icons.more_vert,
                                color: ThemeColors.buttonTextColor
                                    .withOpacity(0.5),
                                size: 16,
                              ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_drop_down,
                              color: isDisabled
                                  ? ThemeColors.buttonTextColor.withOpacity(0.5)
                                  : ThemeColors.primaryColorDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Show text field only when "Other" is selected and showCustomInputWhenOther is true
          if (isOtherSelected)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: TextFormField(
                onChanged: (value) {
                  // Pass the custom value back up
                  if (value.isNotEmpty) {
                    onChanged?.call(value);
                  } else {
                    onChanged?.call('Other');
                  }
                },
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.buttonTextColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter custom ${labelText.toLowerCase()}',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: ThemeColors.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: ThemeColors.primaryColor,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (isOtherSelected && (value == null || value.isEmpty)) {
                    return 'Please enter a custom ${labelText.toLowerCase()}';
                  }
                  return null;
                },
              ),
            ),
        ],
      ),
    );
  }
}
