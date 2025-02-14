import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement profile form with gender etc.
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Gender',
                hintText: 'Enter your gender',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Save profile and create user
              },
              child: const Text('Complete Registration'),
            ),
          ],
        ),
      ),
    );
  }
}