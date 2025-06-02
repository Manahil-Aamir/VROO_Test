import 'package:flutter/material.dart';
import 'input_field.dart';

class CustomTimePicker extends StatelessWidget {
  final String labelText;
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;
  final String? errorText;
  final DateTime? selectedDate; // Add this parameter to know the selected date
  final bool isMaxArrivalTime; // Add this to identify if it's max arrival time picker
  final TimeOfDay? departureTime; // Add this to compare with departure time for max arrival

  const CustomTimePicker({
    super.key,
    required this.labelText,
    required this.selectedTime,
    required this.onTimeSelected,
    this.errorText,
    this.selectedDate, // Add this parameter
    this.isMaxArrivalTime = false, // Add this parameter
    this.departureTime, // Add this parameter
  });

  String _formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  bool _isTimeInPast(TimeOfDay time, DateTime? date, {bool isMaxArrivalTime = false, TimeOfDay? departureTime}) {
    if (date == null) return false;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);
    
    // Only check if the selected date is today
    if (selectedDay.isAtSameMomentAs(today)) {
      DateTime selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      
      // For max arrival time, check if it's next day (after midnight)
      if (isMaxArrivalTime && departureTime != null) {
        final departureDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          departureTime.hour,
          departureTime.minute,
        );
        
        // If max arrival time is earlier in the day than departure time,
        // it means it's next day (e.g., departure 11:45 PM, arrival 12:05 AM)
        if (selectedDateTime.isBefore(departureDateTime)) {
          selectedDateTime = selectedDateTime.add(Duration(days: 1));
          // For next day scenarios, we don't check against current time
          // because it's a future time (next day)
          return false;
        }
      }
      
      return selectedDateTime.isBefore(now);
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InputField(
      keyboardType: TextInputType.number,
      labelText: labelText,
      readOnly: true,
      suffixIcon: const Icon(Icons.access_time),
      controller: TextEditingController(
        text: selectedTime == null ? '' : _formatTimeOfDay(selectedTime!),
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
                    textStyle: theme.textTheme.bodyLarge,
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
                    foregroundColor: theme.primaryColorDark,
                    textStyle: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  cancelButtonStyle: TextButton.styleFrom(
                    foregroundColor: theme.indicatorColor,
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
          // Check if the selected time is in the past when date is today
          if (_isTimeInPast(pickedTime, selectedDate, 
              isMaxArrivalTime: isMaxArrivalTime, 
              departureTime: departureTime)) {
            // Show error message for past time
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isMaxArrivalTime 
                    ? 'Max arrival time cannot be in the past'
                    : 'Cannot select a time in the past for today'),
                backgroundColor: theme.indicatorColor,
              ),
            );
            return; // Don't call onTimeSelected if time is in the past
          }
          
          onTimeSelected(pickedTime);
        }
      },
      errorText: errorText,
    );
  }
}
