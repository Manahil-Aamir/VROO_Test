import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'core/router/navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final regex = RegExp(r'^[A-Za-z]\.[A-Za-z]+\.\d{5}@khi\.iba\.edu\.pk$');
  final testString = 'm.aamir.24441@khi.iba.edu.pk';

  print('Trimmed: "${testString.trim()}"');
  print('Regex match? ${regex.hasMatch(testString.trim())}');

  runApp(
    MultiProvider(
      providers: [
        Provider<Navigation>(
          create: (_) => Navigation(),
        ),
      ],
      child: const App(),
    ),
  );
}
