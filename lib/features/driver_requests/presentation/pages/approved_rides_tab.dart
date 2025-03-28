import 'package:flutter/material.dart';

class ApprovedRidesTab extends StatelessWidget {
  final String rideId;
  const ApprovedRidesTab({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement approved rides list
    return Center(
      child: Text('Approved requests will appear here'),
    );
  }
}