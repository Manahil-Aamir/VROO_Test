import 'package:flutter/material.dart';
import 'package:vroo_test/features/rider_journey/presentation/pages/rider_home_page.dart';
import 'package:vroo_test/ui.dart';

import '../../features/rider_journey/presentation/pages/location_selection_screen.dart';
import '../../features/rider_journey/presentation/pages/r1_page.dart';

class Routes {
  static const String ui = '/ui';
  static const String riderhome = '/riderhome';
  static const String locationSelection = '/location_selection';
  static const String r1Page = '/r1_page'; // New route constant for R1Page

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ui:
        return MaterialPageRoute(builder: (_) => const SimpleUI());
      case riderhome:
        return MaterialPageRoute(builder: (_) => const RiderHomeScreen());
      case locationSelection:
        final arguments = settings.arguments as Map<String, String?>;
        final role = arguments['role'] ??
            'rider'; // Access 'role' from the map, default to 'rider'
        return MaterialPageRoute(
          builder: (_) => LocationSelectionScreen(role: role),
        );
      case r1Page:
        final arguments = settings.arguments as Map<String, String?>;
        return MaterialPageRoute(
          builder: (_) => R1Page(
            fromDescription: arguments['fromDescription'] ?? '',
            toDescription: arguments['toDescription'] ?? '',
            fromPlaceId: arguments['fromPlaceId'] ?? '',
            toPlaceId: arguments['toPlaceId'] ?? '',
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const SimpleUI());
    }
  }
}
