import 'package:flutter/material.dart';

import 'input_field.dart';

class CustomTimePicker extends StatelessWidget {
  final String labelText;
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;
  final String? errorText;

  const CustomTimePicker({
    super.key,
    required this.labelText,
    required this.selectedTime,
    required this.onTimeSelected,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InputField(
      labelText: labelText,
      readOnly: true,
      icon: Icons.access_time,
      controller: TextEditingController(
        text: selectedTime == null
            ? ''
            : '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}', // Ensure two digits for minutes
      ),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: theme.primaryColor,
                    onPrimary: theme.scaffoldBackgroundColor,
                    onSurface: theme.primaryColorDark,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: theme.primaryColor,
                    ),
                  ),
                  timePickerTheme: TimePickerThemeData(
                    dayPeriodColor: theme.primaryColor,
                  )),
              child: child!,
            );
          },
        );
        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
      errorText: errorText,
    );
  }
}
