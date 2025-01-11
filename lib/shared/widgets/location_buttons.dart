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
    );
  }
}
