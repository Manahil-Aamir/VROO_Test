import 'package:flutter/material.dart';
import '../../features/driver_booking/presentation/pages/driver_home_screen.dart';
import '../../features/driver_booking/presentation/pages/location_selection_screen.dart';
import '../../features/driver_booking/presentation/pages/d1.dart';

class Routes {
  static const String ui = '/ui';
  static const String driverHome = '/driver_home';
  static const String locationSelection = '/location_selection';
  static const String d1 = '/d1';

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case driverHome:
        return MaterialPageRoute(builder: (_) => DriverHomeScreen());
      case locationSelection:
        final role = settings.arguments as String? ?? 'driver'; // Default to 'driver'
        return MaterialPageRoute(
          builder: (_) => LocationSelectionScreen(role: role),
        );
      case d1:
        final args = settings.arguments as Map<String, dynamic>;
        final toPlaceID = args['topaceid'] as String;
        final fromPlaceID = args['fromplaceid'] as String;
        final toDescription = args['todescription'] as String;
        final fromDescription = args['fromdescription'] as String;
        return MaterialPageRoute(
          builder: (_) => D1Screen(
            toPlaceID: toPlaceID,
            fromPlaceID: fromPlaceID,
            toDescription: toDescription,
            fromDescription: fromDescription,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: Text("Error")),body: const Center(child: Text("Unknown Route"))));
    
    }
  }
}
