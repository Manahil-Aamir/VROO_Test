import 'package:flutter/material.dart';

class RecurringRow extends StatefulWidget {
  final Function()? onRecurringTap;

  const RecurringRow({super.key, this.onRecurringTap});

  @override
  _RecurringRowState createState() => _RecurringRowState();
}

class _RecurringRowState extends State<RecurringRow> {
  bool isRecurring = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
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
              });
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
                widget.onRecurringTap?.call();
              }
            },
            activeColor: theme.primaryColor,
          ),
        ),
      ],
    );
  }
}
