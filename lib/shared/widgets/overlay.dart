import 'package:flutter/material.dart';

class CustomOverlay extends StatelessWidget {
  const CustomOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: Colors.black.withOpacity(0.5),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(
          color: theme.progressIndicatorTheme.color,
        ),
      ),
    );
  }
}
