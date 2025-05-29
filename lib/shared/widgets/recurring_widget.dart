import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/date_picker.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';
import '../../core/utils/validators/input_ride_validator.dart';

class RecurringWidget extends StatefulWidget {
  final bool initialIsRecurring;
  final String? initialFrequency;
  final Set<String>? initialSelectedDays;
  final DateTime? initialEndDate;
  final Function(bool isRecurring, String? frequency, Set<String>? selectedDays, DateTime? endDate) onRecurrenceChanged;

  const RecurringWidget({
    super.key,
    this.initialIsRecurring = false,
    this.initialFrequency,
    this.initialSelectedDays,
    this.initialEndDate,
    required this.onRecurrenceChanged,
  });

  @override
  _RecurringWidgetState createState() => _RecurringWidgetState();
}

class _RecurringWidgetState extends State<RecurringWidget> {
  late bool isRecurring;
  String? frequency;
  Set<String>? selectedDays;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    isRecurring = widget.initialIsRecurring;
    frequency = widget.initialFrequency;
    selectedDays = widget.initialSelectedDays;
    endDate = widget.initialEndDate;
  }

  @override
  void didUpdateWidget(RecurringWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIsRecurring != widget.initialIsRecurring ||
        oldWidget.initialFrequency != widget.initialFrequency ||
        oldWidget.initialSelectedDays != widget.initialSelectedDays ||
        oldWidget.initialEndDate != widget.initialEndDate) {
      setState(() {
        isRecurring = widget.initialIsRecurring;
        frequency = widget.initialFrequency;
        selectedDays = widget.initialSelectedDays;
        endDate = widget.initialEndDate;
      });
    }
  }

  void _handleRecurrenceChange() {
    widget.onRecurrenceChanged(isRecurring, frequency, selectedDays, endDate);
  }

  Future<void> _showRecurrenceDialog() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0.r)),
      ),
      builder: (context) => RecurrenceDialog(
        initialFrequency: frequency,
        initialSelectedDays: selectedDays,
        initialEndDate: endDate,
      ),
    );

    if (result != null) {
      setState(() {
        frequency = result['recurrenceType'];
        selectedDays = result['selectedDays'] is List 
            ? Set.from(result['selectedDays']) 
            : result['selectedDays'];
        endDate = result['endDate'];
      });
      _handleRecurrenceChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: Text(
                  'One Time',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.primaryColorDark),
                ),
                value: false,
                groupValue: isRecurring,
                onChanged: (value) {
                  setState(() {
                    isRecurring = value!;
                    if (!isRecurring) {
                      // Clear recurring data when switching to one time
                      frequency = null;
                      selectedDays = null;
                      endDate = null;
                    }
                  });
                  _handleRecurrenceChange();
                },
                activeColor: theme.primaryColor,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: Text(
                  'Recurring',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.primaryColorDark),
                ),
                value: true,
                groupValue: isRecurring,
                onChanged: (value) async {
                  setState(() {
                    isRecurring = value!;
                  });
                  if (isRecurring) {
                    await _showRecurrenceDialog();
                  } else {
                    _handleRecurrenceChange();
                  }
                },
                activeColor: theme.primaryColor,
              ),
            ),
          ],
        ),
        // Show recurrence summary if recurring is selected
        if (isRecurring && frequency != null) ...[
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
            ),
            child: Stack(
              children: [
                // Main content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recurrence: $frequency',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.primaryColorDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (frequency == 'Custom' && selectedDays != null && selectedDays!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        'Days: ${selectedDays!.join(', ')}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.primaryColorDark,
                        ),
                      ),
                    ],
                    if (endDate != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        'Until: ${endDate!.day}/${endDate!.month}/${endDate!.year}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.primaryColorDark,
                        ),
                      ),
                    ],
                  ],
                ),
                // Edit icon positioned in top-right
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _showRecurrenceDialog,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 16.sp,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class RecurrenceDialog extends StatefulWidget {
  final String? initialFrequency;
  final Set<String>? initialSelectedDays;
  final DateTime? initialEndDate;

  const RecurrenceDialog({
    super.key,
    this.initialFrequency,
    this.initialSelectedDays,
    this.initialEndDate,
  });

  @override
  RecurrenceDialogState createState() => RecurrenceDialogState();
}

class RecurrenceDialogState extends State<RecurrenceDialog> {
  String recurrenceType = "Daily";
  Set<String> selectedShortDays = {};
  DateTime? endDate;
  bool _dateError = false;

  static const Map<String, String> dayNameMap = {
    "Mon": "Monday",
    "Tues": "Tuesday",
    "Wed": "Wednesday",
    "Thurs": "Thursday",
    "Fri": "Friday",
    "Sat": "Saturday",
    "Sun": "Sunday",
  };

  @override
  void initState() {
    super.initState();
    recurrenceType = widget.initialFrequency ?? "Daily";
    selectedShortDays = widget.initialSelectedDays?.map((fullDay) {
          return dayNameMap.entries
              .firstWhere((e) => e.value == fullDay,
                  orElse: () => const MapEntry('', ''))
              .key;
        }).where((key) => key.isNotEmpty).toSet() ??
        {};
    endDate = widget.initialEndDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Set Recurrence',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColorDark,
            ),
          ),
          SizedBox(height: 16.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRadioOption("Daily"),
              _buildRadioOption("Weekly"),
              _buildRadioOption("Custom"),
            ],
          ),
          SizedBox(height: 16.h),

          if (recurrenceType == "Custom") ...[
            Text(
              'Select Days',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.primaryColorDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              alignment: WrapAlignment.center,
              children: dayNameMap.keys
                  .map((day) => _buildDayChip(day, theme))
                  .toList(),
            ),
            SizedBox(height: 16.h),
          ],

          CustomDatePicker(
            labelText: 'End Date',
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
              if (recurrenceType == "Custom" && selectedShortDays.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select at least one day.")),
                );
                return;
              }

              final fullDayNames = selectedShortDays
                  .map((shortName) => dayNameMap[shortName]!)
                  .toSet();

              Navigator.of(context).pop({
                "recurrenceType": recurrenceType,
                "selectedDays": fullDayNames,
                "endDate": endDate,
              });
            },
            text: 'Save',
          )
        ],
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: recurrenceType,
          activeColor: theme.primaryColor,
          onChanged: (String? newValue) {
            setState(() {
              recurrenceType = newValue!;
              if (recurrenceType != "Custom") {
                selectedShortDays.clear();
              }
            });
          },
        ),
        Text(value,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.primaryColorDark)),
      ],
    );
  }

  Widget _buildDayChip(String shortDay, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedShortDays.contains(shortDay)) {
            selectedShortDays.remove(shortDay);
          } else {
            selectedShortDays.add(shortDay);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedShortDays.contains(shortDay)
              ? theme.primaryColor
              : Colors.white,
          borderRadius: BorderRadius.circular(8.0.r),
          border: Border.all(
            color: theme.primaryColor.withOpacity(0.5),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Text(
          shortDay,
          style: theme.textTheme.bodySmall?.copyWith(
            color: selectedShortDays.contains(shortDay)
                ? Colors.white
                : theme.primaryColorDark,
          ),
        ),
      ),
    );
  }
}
