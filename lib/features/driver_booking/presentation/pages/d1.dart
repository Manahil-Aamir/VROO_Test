import 'package:flutter/material.dart';

class D1Screen extends StatelessWidget {
  final String toPlaceID;
  final String fromPlaceID;
  final String toDescription;
  final String fromDescription;

  const D1Screen({
    super.key,
    required this.toPlaceID,
    required this.fromPlaceID,
    required this.toDescription,
    required this.fromDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('D1 Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To Place ID: $toPlaceID',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'From Place ID: $fromPlaceID',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'To Description: $toDescription',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'From Description: $fromDescription',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
