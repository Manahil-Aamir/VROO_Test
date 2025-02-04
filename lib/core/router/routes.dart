import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vroo_test/features/rider_journey/data/model/preferences_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/schedule_model.dart';
import 'package:vroo_test/features/rider_journey/dependancy_injection/booking_confirm_di.dart';
import 'package:vroo_test/features/rider_journey/dependancy_injection/rider_home_di.dart';
import 'package:vroo_test/features/rider_journey/domain/entity/schedule_entity.dart';
import 'package:vroo_test/features/rider_journey/presentation/pages/rider_home_page.dart';
import 'package:vroo_test/ui.dart';
import '../../features/rider_journey/dependancy_injection/r1_di.dart';
import '../../features/rider_journey/dependancy_injection/r2_di.dart';
import '../../features/rider_journey/dependancy_injection/r3_di.dart';
import '../../features/rider_journey/presentation/pages/booking_confirm_screen.dart';
import '../../features/rider_journey/presentation/pages/location_selection_screen.dart';
import '../../features/rider_journey/presentation/pages/r1_page.dart';
import '../../features/rider_journey/presentation/pages/r2_page.dart';
import '../../features/rider_journey/presentation/pages/r3_page.dart';

class Routes {
  static const String ui = '/ui';
  static const String riderhome = '/riderhome';
  static const String locationSelection = '/location_selection';
  static const String r1Page = '/r1_page';
  static const String r2Page = '/r2_page';
  static const String r3Page = '/r3_page';
  static const String bookingConfirm = '/booking_confirm';

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ui:
        return MaterialPageRoute(builder: (_) => const SimpleUI());
      case riderhome:
        return MaterialPageRoute(
            builder: (_) => MultiProvider(
                providers: RiderHomeDependencyInjection.init(),
                child: const RiderHomeScreen()));
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
      case r3Page:
        final arguments = settings.arguments as Map<String, dynamic>;

        final preferences = arguments['preference'] as PreferencesModel?;
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: R3DependancyInjection.init(),
            child: R3Page(
              schedule: arguments['schedule'] as ScheduleModel,
              preferences: arguments['preferences'] as PreferencesModel,
            ),
          ),
        );
      case '/booking_confirm':
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: BookingConfirmDependencyInjection.init(),
            child: BookingConfirmationScreen(
              rideRequestId: arguments['rideRequestId'] as String,
              matchingRides: arguments['matchingRides'] as List<dynamic>,
              minPickupTime: arguments['minPickupTime'] as TimeOfDay,
              maxPickupTime: arguments['maxPickupTime'] as TimeOfDay,
            ),
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const SimpleUI());
    }
  }
}
