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
      keyboardType: TextInputType.number,
      labelText: labelText,
      readOnly: true,
      suffixIcon: const Icon(Icons.access_time),
      controller: TextEditingController(
        text: selectedTime == null
            ? ''
            : '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}', // Ensure two digits for minutes
      ),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          initialEntryMode: TimePickerEntryMode.dial,
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
                    foregroundColor: theme.primaryColor,
                    textStyle: theme.textTheme.bodyLarge, // Apply text style
                  ),
                ),
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: theme.primaryColorDark,
                ),
                timePickerTheme: TimePickerThemeData(
                  dayPeriodColor: theme.primaryColor,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  timeSelectorSeparatorColor:
                      WidgetStateProperty.all(theme.primaryColor),
                  hourMinuteTextStyle: theme.textTheme.displayMedium?.copyWith(
                    color: theme.primaryColorDark,
                  ),
                  dialTextStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.primaryColorDark,
                  ),
                  helpTextStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.primaryColorDark,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  confirmButtonStyle: TextButton.styleFrom(
                    foregroundColor:
                        theme.primaryColorDark, // Confirm button text color
                    textStyle: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  cancelButtonStyle: TextButton.styleFrom(
                    foregroundColor:
                        theme.indicatorColor, // Cancel button text color
                    textStyle: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
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
