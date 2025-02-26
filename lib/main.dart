import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';
import 'core/router/navigation.dart';
import 'features/notification/data/data_source/notification_remote_data_source.dart';
import 'features/notification/data/repository/notification_repository_impl.dart';
import 'features/notification/dependency_injection/Notification_di.dart';
import 'features/notification/domain/usecases/send_notification_token_usecase.dart';
import 'firebase_options.dart';
import 'core/services/firebase_service.dart';
import 'package:http/http.dart' as http;


// Background handler (must be top-level)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("[BACKGROUND] Received message: ${message.messageId}");
  print("Notification data: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize FCM Service FIRST
  final firebaseService = FirebaseService(
    sendTokenUseCase: SendNotificationTokenUseCase( // Temporary instance
      NotificationRepositoryImpl(
        NotificationRemoteDataSource(http.Client()),
    ),
  ));
  await firebaseService.initializeFCM();

  runApp(
    MultiProvider(
      providers: [
        Provider<Navigation>(create: (_) => Navigation()),
        ...NotificationDependencyInjection.essentialProviders(),
        Provider<FirebaseService>(create: (_) => firebaseService),
      ],
      child: const App(),
    ),
  );
}
