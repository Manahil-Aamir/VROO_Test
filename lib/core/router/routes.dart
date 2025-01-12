import 'package:flutter/material.dart';
import 'package:vroo_test/features/rider_journey/presentation/pages/home_page.dart';
import 'package:vroo_test/ui.dart';

class Routes {
  static const String ui = '/ui ';
  static const String riderhome = '/riderhome';

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ui:
        return MaterialPageRoute(builder: (_) => const SimpleUI());
      case riderhome:
        return MaterialPageRoute(builder: (_) => const RiderHomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SimpleUI());
    }
  }
}
