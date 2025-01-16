import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/date_picker.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';

import '../../core/utils/validators/input_ride_validator.dart';

class RecurrenceDialog extends StatefulWidget {
  const RecurrenceDialog({super.key});

  @override
  RecurrenceDialogState createState() => RecurrenceDialogState();
}

class RecurrenceDialogState extends State<RecurrenceDialog> {
  String recurrenceType = "Daily"; // Default selection
  Set<String> selectedDays = {}; // Store selected days
  DateTime? endDate; // End date for recurrence
  bool _dateError = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Recurrence type options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRadioOption("Daily", "Daily"),
              _buildRadioOption("Weekly", "Weekly"),
              _buildRadioOption("Custom", "Custom"),
            ],
          ),
          SizedBox(height: 16.h),
          // Days of the week (for Weekly/Custom options)
          if (recurrenceType != "Daily")
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              alignment: WrapAlignment.center,
              children: ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"]
                  .map((day) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedDays.contains(day)) {
                        selectedDays.remove(day);
                      } else {
                        selectedDays.add(day);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedDays.contains(day)
                          ? theme.primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.0.r),
                      border: Border.all(
                        color: theme.primaryColorDark,
                        width: 2.0.w,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 12.w,
                    ),
                    child: Text(
                      day,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: selectedDays.contains(day)
                            ? theme.scaffoldBackgroundColor
                            : theme.primaryColorDark,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          SizedBox(height: 16.h),
          // End date selector (Only for "Custom" recurrence)
          if (recurrenceType == "Custom")
            CustomDatePicker(
              labelText: 'Select Date',
              selectedDate: endDate,
              onDateSelected: (pickedDate) {
                setState(() {
                  endDate = pickedDate;
                  _dateError = InputRideValidator.validateDate(endDate) != null;
                });
              },
              errorText: _dateError ? 'Please select a valid date' : null,
            ),

          SizedBox(height: 16.h),
          GradientButton(
            onTap: () {
              if (recurrenceType != "Daily" && selectedDays.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please select at least one day.")),
                );
                return;
              }
              Navigator.of(context).pop({
                "recurrenceType": recurrenceType,
                "selectedDays": selectedDays,
                "endDate": endDate,
              });
            },
            text: 'Save',
          )
        ],
      ),
    );
  }

  Widget _buildRadioOption(String value, String label) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: recurrenceType,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (String? newValue) {
            setState(() {
              recurrenceType = newValue!;
              if (recurrenceType == "Daily" || recurrenceType == "Weekly") {
                selectedDays.clear();
                endDate = null; // Reset end date
              }
            });
          },
        ),
        Text(label,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.primaryColorDark)),
      ],
    );
  }
}

void showRecurrenceDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0.r)),
    ),
    builder: (context) {
      return RecurrenceDialog();
    },
  );
}
