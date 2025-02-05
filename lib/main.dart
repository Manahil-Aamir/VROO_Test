import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'core/router/navigation.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        Provider<Navigation>(
            create: (_) => Navigation()), // ✅ Provide Navigation globally
      ],
      child: const App(),
    ),
  );
}
