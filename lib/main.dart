import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vroo_test/features/authentication/dependency_injection/user_di.dart';
import 'app/app.dart';
import 'core/router/navigation.dart';
import 'features/HomeScreens/dependency_injection/role_di.dart';
import 'firebase_options.dart';
import 'core/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register background handler from FirebaseService
  FirebaseMessaging.onBackgroundMessage(
    FirebaseService.handleBackgroundMessage, // Static reference
  );

  final prefs = await SharedPreferences.getInstance();

  // Initialize FCM Service FIRST
  final firebaseService = FirebaseService();
  await firebaseService.initializeFCM();

  runApp(
    MultiProvider(
      providers: [
        ...await RoleDependencyInjection.init(),
        ...UserDi.init(),
        Provider<SharedPreferences>(create: (_) => prefs),
        Provider<Navigation>(create: (_) => Navigation()),
        Provider<FirebaseService>(create: (_) => firebaseService),
      ],
      child: const App(),
    ),
  );
}
