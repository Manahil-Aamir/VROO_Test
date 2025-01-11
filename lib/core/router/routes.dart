import 'package:flutter/material.dart';
import 'package:vroo_test/ui.dart';

import '../../features/driver_booking/presentation/pages/driver_home_screen.dart';
import '../../features/driver_booking/presentation/pages/location_selection_screen.dart';

class Routes {
  static const String ui = '/ui ';
  static const String driverHome = '/driver_home';
  static const String locationSelection = '/location_selection';

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case driverHome:
        return MaterialPageRoute(builder: (_) => DriverHomeScreen());
      case locationSelection:
        return MaterialPageRoute(builder: (_) => LocationSelectionScreen(role: 'driver',));
      default:
        return MaterialPageRoute(builder: (_) => const SimpleUI());
    }
  }
}
