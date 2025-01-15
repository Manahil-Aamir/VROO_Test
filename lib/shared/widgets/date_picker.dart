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
    return InputField(
      labelText: labelText,
      readOnly: true,
      icon: Icons.calendar_today,
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
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: const Color(0xFFEC8825),
                  onPrimary: Colors.white,
                  onSurface: const Color(0xFF434143),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFEC8825),
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
