import 'package:flutter/material.dart';
import 'location_button.dart';

class LocationButtons extends StatelessWidget {
  final VoidCallback onStartingPointTap;
  final VoidCallback onDestinationTap;

  const LocationButtons({
    Key? key,
    required this.onStartingPointTap,
    required this.onDestinationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).primaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
          ),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          LocationButton(
            label: 'Starting Point',
            onTap: onStartingPointTap,
          ),
          const SizedBox(height: 10),
          LocationButton(
            label: 'Destination',
            onTap: onDestinationTap,
          ),
        ],
          ),
        ),
      ],
      // children: [
      //   LocationButton(
      //     label: 'Starting Point',
      //     onTap: onStartingPointTap,
      //   ),
      //   const SizedBox(height: 10),
      //   LocationButton(
      //     label: 'Destination',
      //     onTap: onDestinationTap,
      //   ),
      // ],
    
    );
  }
}
