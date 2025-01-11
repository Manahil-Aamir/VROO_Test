import 'package:flutter/material.dart';
import 'package:vroo_test/ui.dart';

class Routes {
  static const String ui = '/ui ';

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ui:
        return MaterialPageRoute(builder: (_) => const SimpleUI());
      default:
        return MaterialPageRoute(builder: (_) => const SimpleUI());
    }
  }
}
