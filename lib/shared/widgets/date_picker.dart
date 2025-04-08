import 'package:flutter/material.dart';
import 'input_field.dart';

import 'package:flutter/material.dart';
import 'input_field.dart';

class CustomDatePicker extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String? errorText;

  const CustomDatePicker({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onDateSelected,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    print('i am here');
    final theme = Theme.of(context);
    return InputField(
      labelText: labelText,
      readOnly: true,
      suffixIcon: Icon(Icons.calendar_today),
      controller: TextEditingController(
        text: selectedDate == null
            ? ''
            : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
          initialEntryMode:
              DatePickerEntryMode.calendar, // Calendar mode by default
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: theme.copyWith(
                colorScheme: ColorScheme.light(
                  primary: const Color(0xFFEC8825),
                  onPrimary: Colors.white,
                  onSurface: const Color(0xFF434143),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFEC8825),
                    textStyle:
                        theme.textTheme.bodyLarge, // Ensuring proper text style
                  ),
                ),
                dialogTheme: DialogTheme(
                  titleTextStyle: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                  contentTextStyle: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    color: theme.primaryColorDark,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      errorText: errorText,
    );
  }
}
