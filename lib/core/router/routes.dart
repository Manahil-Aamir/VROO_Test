import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vroo_test/features/rider_journey/data/model/schedule_model.dart';
import 'package:vroo_test/features/rider_journey/domain/entity/schedule_entity.dart';
import 'package:vroo_test/features/rider_journey/presentation/pages/rider_home_page.dart';
import 'package:vroo_test/ui.dart';

import '../../features/rider_journey/dependancy_injection/r1_di.dart';
import '../../features/rider_journey/dependancy_injection/r2_di.dart';
import '../../features/rider_journey/presentation/pages/location_selection_screen.dart';
import '../../features/rider_journey/presentation/pages/r1_page.dart';
import '../../features/rider_journey/presentation/pages/r2_page.dart';

class Routes {
  static const String ui = '/ui';
  static const String riderhome = '/riderhome';
  static const String locationSelection = '/location_selection';
  static const String r1Page = '/r1_page';
  static const String r2Page = '/r2_page';

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
          builder: (_) => MultiProvider(
            providers: R1DependencyInjection.init(),
            child: R1Page(
              fromDescription: arguments['fromDescription'] ?? '',
              toDescription: arguments['toDescription'] ?? '',
              fromPlaceId: arguments['fromPlaceId'] ?? '',
              toPlaceId: arguments['toPlaceId'] ?? '',
            ),
          ),
        );
      case r2Page:
        final arguments = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: R2DependencyInjection.init(),
            child: R2Page(schedule: arguments['schedule'] as ScheduleModel),
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const SimpleUI());
    }
  }
}
