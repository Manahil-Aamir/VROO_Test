import 'package:flutter/material.dart';
import 'package:vroo_test/features/rider_journey/presentation/pages/rider_home_page.dart';
import 'package:vroo_test/ui.dart';

import '../../features/rider_journey/presentation/pages/location_selection_screen.dart';

class Routes {
  static const String ui = '/ui ';
  static const String riderhome = '/riderhome';
  static const String locationSelection = '/location_selection';

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ui:
        return MaterialPageRoute(builder: (_) => const SimpleUI());
      case riderhome:
        return MaterialPageRoute(builder: (_) => const RiderHomeScreen());
      case locationSelection:
        final arguments = settings.arguments as Map<String, String>;
        final role = arguments['role'] ??
            'rider'; // Access 'role' from the map, default to 'rider'
        return MaterialPageRoute(
          builder: (_) => LocationSelectionScreen(role: role),
        );

      default:
        return MaterialPageRoute(builder: (_) => const SimpleUI());
    }
  }
}
