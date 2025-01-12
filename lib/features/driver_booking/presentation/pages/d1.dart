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
      body: const Center(
        child: Text(
          'Welcome to D1 Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
