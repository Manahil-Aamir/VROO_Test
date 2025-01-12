import 'package:flutter/material.dart';

class D1Screen extends StatelessWidget {
  const D1Screen({super.key});

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
