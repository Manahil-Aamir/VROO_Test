import 'package:flutter/material.dart';
import 'package:vroo_test/core/theme/color/color_theme.dart';

class FormFieldContainer extends StatelessWidget {
  final String labelText;
  final Widget child;
  final String? errorText;

  const FormFieldContainer({
    super.key,
    required this.labelText,
    required this.child,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: theme.inputDecorationTheme.labelStyle,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null
                  ? ThemeColors.accentColor
                  : ThemeColors.primaryColorLight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: ThemeColors.accentColor,
              ),
            ),
          ),
      ],
    );
  }
}
