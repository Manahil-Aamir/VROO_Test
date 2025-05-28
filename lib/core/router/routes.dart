import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vroo_test/features/authentication/dependency_injection/sign_in_di.dart';
import 'package:vroo_test/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:vroo_test/features/cars/presentation/pages/cars_screen.dart';
import 'package:vroo_test/features/chat/domain/entity/chat_user.dart';
import 'package:vroo_test/features/chat/presentation/pages/chat_detail_screen.dart';
import 'package:vroo_test/features/ride_start/dependancy_injection/ridestart_di.dart';
import 'package:vroo_test/features/ride_start/dependancy_injection/rideview_di.dart';
import 'package:vroo_test/features/ride_start/presentation/pages/ride_static_page.dart';
import 'package:vroo_test/features/ride_start/presentation/pages/ride_tracking_page.dart';
import 'package:vroo_test/features/ride_start/presentation/pages/ride_view_screen.dart';
import 'package:vroo_test/features/matching/data/models/matching_rides_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/source_and_dest_model.dart';
import 'package:vroo_test/features/safety/presentation/pages/protect.dart';
import 'package:vroo_test/features/safety/presentation/pages/report.dart';
import 'package:vroo_test/features/safety/presentation/pages/route.dart';
import 'package:vroo_test/features/safety/presentation/pages/safecontact.dart';
import 'package:vroo_test/features/safety/presentation/pages/safety.dart';
import 'package:vroo_test/features/safety/presentation/pages/userverify.dart';
import 'package:vroo_test/features/user_profile/presentation/pages/user_profile_page.dart';
import 'package:vroo_test/features/sos/dependancy_injection/sos_di.dart';
import 'package:vroo_test/features/sos/presentation/pages/sos_page.dart';
import '../../features/HomeScreens/dependency_injection/home_di.dart';
import '../../features/HomeScreens/dependency_injection/location_di.dart';
import '../../features/HomeScreens/presentation/pages/home_screen.dart';
import '../../features/HomeScreens/presentation/pages/location_selection.dart';
import '../../features/cars/dependency_injection/car_di.dart';
import '../../features/chat/dependency_injection/chat_di.dart';
import '../../features/chat/presentation/pages/chat_screen.dart';
import '../../features/driver_booking/dependency_injection/booking_di.dart';
import '../../features/driver_booking/dependency_injection/d1_di.dart';
import '../../features/driver_booking/dependency_injection/d2_di.dart';
import '../../features/driver_booking/dependency_injection/d3_di.dart';
import '../../features/cars/domain/entity/car.dart';
import '../../features/driver_booking/presentation/pages/BookingConfirmationDriver.dart';
import '../../features/driver_booking/presentation/pages/d1.dart';
import '../../features/driver_booking/presentation/pages/d2.dart';
import '../../features/driver_booking/presentation/pages/d3.dart';
import '../../features/driver_booking/presentation/pages/route_display_page.dart';
import 'package:vroo_test/features/rider_journey/data/model/preferences_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/schedule_model.dart';
import 'package:vroo_test/features/rider_journey/dependancy_injection/booking_confirm_di.dart';
import '../../features/driver_requests/dependency_injection/active_rides_di.dart';
import '../../features/driver_requests/dependency_injection/approve_rides_di.dart';
import '../../features/driver_requests/dependency_injection/pending_rides_di.dart';
import '../../features/driver_requests/presentation/pages/active_rides_screen.dart';
import '../../features/driver_requests/presentation/pages/ride_request_status.dart';
import '../../features/matching/dependency_injection/matching_di.dart';
import '../../features/matching/presentation/pages/matching_page.dart';
import '../../features/ride_start/data/models/ridestart_data_model.dart';
import '../../features/rider_journey/dependancy_injection/r1_di.dart';
import '../../features/rider_journey/dependancy_injection/r2_di.dart';
import '../../features/rider_journey/dependancy_injection/r3_di.dart';
import '../../features/rider_journey/presentation/pages/booking_confirm_screen.dart';
import '../../features/rider_journey/presentation/pages/r1_page.dart';
import '../../features/rider_journey/presentation/pages/r2_page.dart';
import '../../features/rider_journey/presentation/pages/r3_page.dart';
import '../../features/authentication/dependency_injection/auth_di.dart';
import '../../features/authentication/dependency_injection/create_user_di.dart';
import '../../features/authentication/presentation/pages/email_verification_screen.dart';
import '../../features/authentication/presentation/pages/create_user_screen.dart';
import '../../features/authentication/presentation/pages/signup_screen.dart';
import '../../features/rider_requests/dependency_injection/ride_request_joins_di.dart';
import '../../features/rider_requests/dependency_injection/rider_request_di.dart';
import '../../features/rider_requests/presentation/pages/rider_request_join.dart';
import '../../features/rider_requests/presentation/pages/rider_requests_screen.dart';
import '../../features/safety/presentation/pages/beforeride.dart';
import '../../features/sos/presentation/pages/contact_page.dart';
import '../../features/user_profile/dependency_injection/user_profile_di.dart';
import '../../splash.dart';

class Routes {
  static const String ui = '/ui';
  static const String splash = '/splash';
  static const String locationSelectionDriver = '/location_selection_driver';
  static const String routeDisplayPage = '/route_display_page';
  static const String d1 = '/d1';
  static const String d2 = '/d2';
  static const String d3 = '/d3';
  static const String active_rides_driver = '/active_ride_driver';
  static const String booking_confirm = '/booking_confirm_driver';
  static const String ride_request_status = '/ride_request_status';
  static const String riderhome = '/riderhome';
  static const String locationSelection = '/location_selection';
  static const String r1Page = '/r1_page';
  static const String r2Page = '/r2_page';
  static const String r3Page = '/r3_page';
  static const String bookingConfirm = '/booking_confirm';
  static const String matching_rides = '/matching_rides';
  static const String sign_up = '/sign_up';
  static const String sign_in = '/sign_in';
  static const String emailVerification = '/email-verification';
  static const String create_user = '/create_user';
  static const String home = '/home';
  static const String location = '/location';
  static const String chat = '/chat';
  static const String chat_detail = '/chat_detail';
  static const String user_profile = '/user_profile';
  static const String car = '/car';
  static const String sos = '/sos';
  static const String emergency_contacts = '/emergency_contacts';
  static const String ride_request_rider = '/ride_request_rider';
  static const String static_page = '/static_page';
  static const String ride_tracking = '/ride_tracking';
  static const String rider_view = '/rider_view';
  static const String rider_request_joins = '/rider_request_joins';
  static const String safety = '/safety';
  static const String before_ride = '/before_ride';
  static const String protect = '/protect';
  static const String user_verify = '/user_verify';
  static const String route = '/route';
  static const String report = '/report';
  static const String safecontact = '/safecontact';

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            // Use MultiBlocProvider instead of MultiProvider
            providers: [
              ...HomeDependencyInjection.init(),
              ...SosDependencyInjection.init(),
            ],

            child: const HomeScreen(),
          ),
        );
      case location:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: LocationDependencyInjection.init(),
            child: const LocationSelectionScreen(),
          ),
        );
      case routeDisplayPage:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final toPlaceID =
            args['toPlaceId'] as String? ?? 'ChIJ9SEZ0Lw4sz4RhAdTxTaH2V8';
        final fromPlaceID =
            args['fromPlaceId'] as String? ?? 'ChIJOyUu0UQ-sz4RzFgD4rLU7PI';
        final toDescription = args['toDescription'] as String? ??
            'IBA, University Rd, University Of Karachi, Karachi, Pakistan';
        final fromDescription = args['fromDescription'] as String? ??
            'Adenwala Apartments، Britto Road, Soldier Bazaar Garden East, Karachi, Pakistan';
        return MaterialPageRoute(
          builder: (_) => RouteDisplayPage(
            toPlaceDesc: toDescription,
            fromPlaceDesc: fromDescription,
            toPlaceId: toPlaceID,
            fromPlaceId: fromPlaceID,
          ),
        );
      case d1:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final toPlaceID =
            args['toPlaceID'] as String? ?? 'ChIJ9SEZ0Lw4sz4RhAdTxTaH2V8';
        final fromPlaceID =
            args['fromPlaceID'] as String? ?? 'ChIJOyUu0UQ-sz4RzFgD4rLU7PI';
        final toDescription = args['toDescription'] as String? ??
            'IBA, University Rd, University Of Karachi, Karachi, Pakistan';
        final fromDescription = args['fromDescription'] as String? ??
            'Adenwala Apartments، Britto Road, Soldier Bazaar Garden East, Karachi, Pakistan';
        final selectedRouteCoords =
            args['selectedRouteCoords'] as List<dynamic>? ??
                [
                  [24.880770000000002, 67.03389],
                  [24.880460000000003, 67.03394],
                  [24.879330000000003, 67.03405000000001],
                  [24.878680000000003, 67.03411000000001],
                  [24.878280000000004, 67.03417],
                  [24.877660000000002, 67.03433000000001],
                  [24.877350000000003, 67.0344],
                  [24.877160000000003, 67.03445],
                  [24.877200000000002, 67.03451000000001],
                  [24.8775, 67.03509000000001],
                  [24.877930000000003, 67.03588],
                  [24.87845, 67.03686],
                  [24.87909, 67.03802],
                  [24.879340000000003, 67.03848],
                  [24.87965, 67.03885000000001],
                  [24.879790000000003, 67.03895],
                  [24.880080000000003, 67.03902000000001],
                  [24.88033, 67.03902000000001],
                  [24.880570000000002, 67.03907000000001],
                  [24.88071, 67.03912000000001],
                  [24.880760000000002, 67.03924],
                  [24.88079, 67.03930000000001],
                  [24.88081, 67.03947000000001],
                  [24.88081, 67.03960000000001],
                  [24.88071, 67.03985],
                  [24.880530000000004, 67.04024000000001],
                  [24.88041, 67.04055000000001],
                  [24.88041, 67.04068000000001],
                  [24.880470000000003, 67.04083],
                  [24.880630000000004, 67.04121],
                  [24.879060000000003, 67.04239000000001],
                  [24.879050000000003, 67.04244],
                  [24.879030000000004, 67.04248000000001],
                  [24.87901, 67.0425],
                  [24.87901, 67.04328000000001],
                  [24.87901, 67.0451],
                  [24.879, 67.0458],
                  [24.879070000000002, 67.0462],
                  [24.8791, 67.04649],
                  [24.8791, 67.04659000000001],
                  [24.879140000000003, 67.04671],
                  [24.879230000000003, 67.04693],
                  [24.879340000000003, 67.04715],
                  [24.88041, 67.04893],
                  [24.88052, 67.04914000000001],
                  [24.88088, 67.04968000000001],
                  [24.88163, 67.05102000000001],
                  [24.881850000000004, 67.05143000000001],
                  [24.88238, 67.0523],
                  [24.88333, 67.05382],
                  [24.883460000000003, 67.05404],
                  [24.883670000000002, 67.05443000000001],
                  [24.883950000000002, 67.05488000000001],
                  [24.88437, 67.05557],
                  [24.884570000000004, 67.05592],
                  [24.88492, 67.05653000000001],
                  [24.885040000000004, 67.05669],
                  [24.885160000000003, 67.05682],
                  [24.88531, 67.05693000000001],
                  [24.88585, 67.05734000000001],
                  [24.887200000000004, 67.05845000000001],
                  [24.888620000000003, 67.05959],
                  [24.889490000000002, 67.06027],
                  [24.890400000000003, 67.06097000000001],
                  [24.89084, 67.06135],
                  [24.89103, 67.06155000000001],
                  [24.8914, 67.06197],
                  [24.89159, 67.06216],
                  [24.89251, 67.06296],
                  [24.894150000000003, 67.06438],
                  [24.895310000000002, 67.06536000000001],
                  [24.896060000000002, 67.06602000000001],
                  [24.89648, 67.0664],
                  [24.89665, 67.06663],
                  [24.89693, 67.06701000000001],
                  [24.897370000000002, 67.0677],
                  [24.89788, 67.06845],
                  [24.89816, 67.06883],
                  [24.898290000000003, 67.06901],
                  [24.89836, 67.06916000000001],
                  [24.899330000000003, 67.07051],
                  [24.900080000000003, 67.07157000000001],
                  [24.9003, 67.07187],
                  [24.900760000000002, 67.07254],
                  [24.900910000000003, 67.07292000000001],
                  [24.901120000000002, 67.07322],
                  [24.901500000000002, 67.07382000000001],
                  [24.90264, 67.0754],
                  [24.90292, 67.07579000000001],
                  [24.902980000000003, 67.07588000000001],
                  [24.90305, 67.07582000000001],
                  [24.903480000000002, 67.07646000000001],
                  [24.903740000000003, 67.07684],
                  [24.904300000000003, 67.07768],
                  [24.904750000000003, 67.07832],
                  [24.904940000000003, 67.07855],
                  [24.90566, 67.07959000000001],
                  [24.90602, 67.08012000000001],
                  [24.90622, 67.08039000000001],
                  [24.9063, 67.0805],
                  [24.906180000000003, 67.08062000000001],
                  [24.906380000000002, 67.08087],
                  [24.906810000000004, 67.08142000000001],
                  [24.906950000000002, 67.08161000000001],
                  [24.90745, 67.08239],
                  [24.908500000000004, 67.0839],
                  [24.90968, 67.08561],
                  [24.910870000000003, 67.08734000000001],
                  [24.91147, 67.08825],
                  [24.911880000000004, 67.08887],
                  [24.912380000000002, 67.08963],
                  [24.912920000000003, 67.09042000000001],
                  [24.913580000000003, 67.09132000000001],
                  [24.914060000000003, 67.09195000000001],
                  [24.914930000000002, 67.09312],
                  [24.91673, 67.09557000000001],
                  [24.91719, 67.09618],
                  [24.91767, 67.09677],
                  [24.918380000000003, 67.09769],
                  [24.920270000000002, 67.10015],
                  [24.92085, 67.10088],
                  [24.92244, 67.10298],
                  [24.92303, 67.10372000000001],
                  [24.923440000000003, 67.10419],
                  [24.92432, 67.10538000000001],
                  [24.924750000000003, 67.10595],
                  [24.925530000000002, 67.10696],
                  [24.925990000000002, 67.10762000000001],
                  [24.926330000000004, 67.10831],
                  [24.926430000000003, 67.1085],
                  [24.92735, 67.11053000000001],
                  [24.927960000000002, 67.11183000000001],
                  [24.92913, 67.11424000000001],
                  [24.929660000000002, 67.11535],
                  [24.93014, 67.11636],
                  [24.93045, 67.11719000000001],
                  [24.93082, 67.11816],
                  [24.930860000000003, 67.11814000000001],
                  [24.930870000000002, 67.11813000000001],
                  [24.930880000000002, 67.11811],
                  [24.930880000000002, 67.11810000000001],
                  [24.93129, 67.11838],
                  [24.931330000000003, 67.11843],
                  [24.931420000000003, 67.11841000000001],
                  [24.93343, 67.11909],
                  [24.934400000000004, 67.11942],
                  [24.93549, 67.11977],
                  [24.935900000000004, 67.11978],
                  [24.93614, 67.11974000000001],
                  [24.93636, 67.11966000000001],
                  [24.93739, 67.11905],
                  [24.937400000000004, 67.11904000000001],
                  [24.937410000000003, 67.11902],
                  [24.937430000000003, 67.11901],
                  [24.937440000000002, 67.11901],
                  [24.93746, 67.11901],
                  [24.937820000000002, 67.11879],
                  [24.93851, 67.11841000000001],
                  [24.939200000000003, 67.11800000000001],
                  [24.93946, 67.11785],
                  [24.9401, 67.11745],
                  [24.94075, 67.11708],
                  [24.94085, 67.11701000000001],
                  [24.940600000000003, 67.11648000000001],
                  [24.940340000000003, 67.11594000000001],
                  [24.94048, 67.11586000000001],
                  [24.940520000000003, 67.11594000000001],
                  [24.94132, 67.11550000000001],
                  [24.94169, 67.11529],
                  [24.94217, 67.11501000000001],
                  [24.941820000000003, 67.11433000000001]
                ];
        final distance = args['distance'] as String? ?? '12.9 km';
        final duration = args['duration'] as String? ?? '50 mins';
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: D1DependencyInjection.init(),
            child: D1Page(
              toPlaceId: toPlaceID,
              fromPlaceId: fromPlaceID,
              toDescription: toDescription,
              fromDescription: fromDescription,
              selectedRouteCoords: selectedRouteCoords,
              distance: distance,
              duration: duration,
            ),
          ),
        );
      case d2:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final toPlaceID =
            args['toPlaceID'] as String? ?? 'ChIJ9SEZ0Lw4sz4RhAdTxTaH2V8';
        final fromPlaceID =
            args['fromPlaceID'] as String? ?? 'ChIJOyUu0UQ-sz4RzFgD4rLU7PI';
        final toDescription = args['toDescription'] as String? ??
            'IBA, University Rd, University Of Karachi, Karachi, Pakistan';
        final fromDescription = args['fromDescription'] as String? ??
            'Adenwala Apartments، Britto Road, Soldier Bazaar Garden East, Karachi, Pakistan';
        final selectedRouteCoords =
            args['selectedRouteCoords'] as List<dynamic>? ??
                [
                  [24.880770000000002, 67.03389],
                  [24.880460000000003, 67.03394],
                  [24.879330000000003, 67.03405000000001],
                  [24.878680000000003, 67.03411000000001],
                  [24.878280000000004, 67.03417],
                  [24.877660000000002, 67.03433000000001],
                  [24.877350000000003, 67.0344],
                  [24.877160000000003, 67.03445],
                  [24.877200000000002, 67.03451000000001],
                  [24.8775, 67.03509000000001],
                  [24.877930000000003, 67.03588],
                  [24.87845, 67.03686],
                  [24.87909, 67.03802],
                  [24.879340000000003, 67.03848],
                  [24.87965, 67.03885000000001],
                  [24.879790000000003, 67.03895],
                  [24.880080000000003, 67.03902000000001],
                  [24.88033, 67.03902000000001],
                  [24.880570000000002, 67.03907000000001],
                  [24.88071, 67.03912000000001],
                  [24.880760000000002, 67.03924],
                  [24.88079, 67.03930000000001],
                  [24.88081, 67.03947000000001],
                  [24.88081, 67.03960000000001],
                  [24.88071, 67.03985],
                  [24.880530000000004, 67.04024000000001],
                  [24.88041, 67.04055000000001],
                  [24.88041, 67.04068000000001],
                  [24.880470000000003, 67.04083],
                  [24.880630000000004, 67.04121],
                  [24.879060000000003, 67.04239000000001],
                  [24.879050000000003, 67.04244],
                  [24.879030000000004, 67.04248000000001],
                  [24.87901, 67.0425],
                  [24.87901, 67.04328000000001],
                  [24.87901, 67.0451],
                  [24.879, 67.0458],
                  [24.879070000000002, 67.0462],
                  [24.8791, 67.04649],
                  [24.8791, 67.04659000000001],
                  [24.879140000000003, 67.04671],
                  [24.879230000000003, 67.04693],
                  [24.879340000000003, 67.04715],
                  [24.88041, 67.04893],
                  [24.88052, 67.04914000000001],
                  [24.88088, 67.04968000000001],
                  [24.88163, 67.05102000000001],
                  [24.881850000000004, 67.05143000000001],
                  [24.88238, 67.0523],
                  [24.88333, 67.05382],
                  [24.883460000000003, 67.05404],
                  [24.883670000000002, 67.05443000000001],
                  [24.883950000000002, 67.05488000000001],
                  [24.88437, 67.05557],
                  [24.884570000000004, 67.05592],
                  [24.88492, 67.05653000000001],
                  [24.885040000000004, 67.05669],
                  [24.885160000000003, 67.05682],
                  [24.88531, 67.05693000000001],
                  [24.88585, 67.05734000000001],
                  [24.887200000000004, 67.05845000000001],
                  [24.888620000000003, 67.05959],
                  [24.889490000000002, 67.06027],
                  [24.890400000000003, 67.06097000000001],
                  [24.89084, 67.06135],
                  [24.89103, 67.06155000000001],
                  [24.8914, 67.06197],
                  [24.89159, 67.06216],
                  [24.89251, 67.06296],
                  [24.894150000000003, 67.06438],
                  [24.895310000000002, 67.06536000000001],
                  [24.896060000000002, 67.06602000000001],
                  [24.89648, 67.0664],
                  [24.89665, 67.06663],
                  [24.89693, 67.06701000000001],
                  [24.897370000000002, 67.0677],
                  [24.89788, 67.06845],
                  [24.89816, 67.06883],
                  [24.898290000000003, 67.06901],
                  [24.89836, 67.06916000000001],
                  [24.899330000000003, 67.07051],
                  [24.900080000000003, 67.07157000000001],
                  [24.9003, 67.07187],
                  [24.900760000000002, 67.07254],
                  [24.900910000000003, 67.07292000000001],
                  [24.901120000000002, 67.07322],
                  [24.901500000000002, 67.07382000000001],
                  [24.90264, 67.0754],
                  [24.90292, 67.07579000000001],
                  [24.902980000000003, 67.07588000000001],
                  [24.90305, 67.07582000000001],
                  [24.903480000000002, 67.07646000000001],
                  [24.903740000000003, 67.07684],
                  [24.904300000000003, 67.07768],
                  [24.904750000000003, 67.07832],
                  [24.904940000000003, 67.07855],
                  [24.90566, 67.07959000000001],
                  [24.90602, 67.08012000000001],
                  [24.90622, 67.08039000000001],
                  [24.9063, 67.0805],
                  [24.906180000000003, 67.08062000000001],
                  [24.906380000000002, 67.08087],
                  [24.906810000000004, 67.08142000000001],
                  [24.906950000000002, 67.08161000000001],
                  [24.90745, 67.08239],
                  [24.908500000000004, 67.0839],
                  [24.90968, 67.08561],
                  [24.910870000000003, 67.08734000000001],
                  [24.91147, 67.08825],
                  [24.911880000000004, 67.08887],
                  [24.912380000000002, 67.08963],
                  [24.912920000000003, 67.09042000000001],
                  [24.913580000000003, 67.09132000000001],
                  [24.914060000000003, 67.09195000000001],
                  [24.914930000000002, 67.09312],
                  [24.91673, 67.09557000000001],
                  [24.91719, 67.09618],
                  [24.91767, 67.09677],
                  [24.918380000000003, 67.09769],
                  [24.920270000000002, 67.10015],
                  [24.92085, 67.10088],
                  [24.92244, 67.10298],
                  [24.92303, 67.10372000000001],
                  [24.923440000000003, 67.10419],
                  [24.92432, 67.10538000000001],
                  [24.924750000000003, 67.10595],
                  [24.925530000000002, 67.10696],
                  [24.925990000000002, 67.10762000000001],
                  [24.926330000000004, 67.10831],
                  [24.926430000000003, 67.1085],
                  [24.92735, 67.11053000000001],
                  [24.927960000000002, 67.11183000000001],
                  [24.92913, 67.11424000000001],
                  [24.929660000000002, 67.11535],
                  [24.93014, 67.11636],
                  [24.93045, 67.11719000000001],
                  [24.93082, 67.11816],
                  [24.930860000000003, 67.11814000000001],
                  [24.930870000000002, 67.11813000000001],
                  [24.930880000000002, 67.11811],
                  [24.930880000000002, 67.11810000000001],
                  [24.93129, 67.11838],
                  [24.931330000000003, 67.11843],
                  [24.931420000000003, 67.11841000000001],
                  [24.93343, 67.11909],
                  [24.934400000000004, 67.11942],
                  [24.93549, 67.11977],
                  [24.935900000000004, 67.11978],
                  [24.93614, 67.11974000000001],
                  [24.93636, 67.11966000000001],
                  [24.93739, 67.11905],
                  [24.937400000000004, 67.11904000000001],
                  [24.937410000000003, 67.11902],
                  [24.937430000000003, 67.11901],
                  [24.937440000000002, 67.11901],
                  [24.93746, 67.11901],
                  [24.937820000000002, 67.11879],
                  [24.93851, 67.11841000000001],
                  [24.939200000000003, 67.11800000000001],
                  [24.93946, 67.11785],
                  [24.9401, 67.11745],
                  [24.94075, 67.11708],
                  [24.94085, 67.11701000000001],
                  [24.940600000000003, 67.11648000000001],
                  [24.940340000000003, 67.11594000000001],
                  [24.94048, 67.11586000000001],
                  [24.940520000000003, 67.11594000000001],
                  [24.94132, 67.11550000000001],
                  [24.94169, 67.11529],
                  [24.94217, 67.11501000000001],
                  [24.941820000000003, 67.11433000000001]
                ];
        final selectedDate =
            args['selectedDate'] as DateTime? ?? DateTime.now();
        final selectedTime =
            args['selectedTime'] as TimeOfDay? ?? TimeOfDay.now();
        final maxArrivalTime =
            args['maxArrivalTime'] as TimeOfDay? ?? TimeOfDay.now();
        final distance = args['distance'] as String? ?? '12.9 km';
        final duration = args['duration'] as String? ?? '50 mins';
        final recurrence = args['recurrence'] as String? ?? 'One Time';
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ...D2DependencyInjection.init(),
              ...CarDependencyInjection.init(),
            ],
            child: D2Page(
              toPlaceId: toPlaceID,
              fromPlaceId: fromPlaceID,
              toDescription: toDescription,
              fromDescription: fromDescription,
              date: selectedDate,
              time: selectedTime,
              maxArrivalTime: maxArrivalTime,
              routeDistance: distance,
              routeDuration: duration,
              selectedRouteCoords: selectedRouteCoords,
              recurrence: recurrence,
            ),
          ),
        );
      case d3:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final fromPlaceID =
            args['fromPlaceID'] as String? ?? 'ChIJOyUu0UQ-sz4RzFgD4rLU7PI';
        final toPlaceID =
            args['toPlaceID'] as String? ?? 'ChIJ9SEZ0Lw4sz4RhAdTxTaH2V8';
        final fromDescription = args['fromDescription'] as String? ??
            'Adenwala Apartments، Britto Road, Soldier Bazaar Garden East, Karachi, Pakistan';
        final toDescription = args['toDescription'] as String? ??
            'IBA, University Rd, University Of Karachi, Karachi, Pakistan';
        final routeCoords = args['routeCoords'] as List<dynamic>? ?? [];
        final date = args['date'] as DateTime? ?? DateTime.now();
        final time = args['time'] as TimeOfDay? ?? TimeOfDay.now();
        final maxArrivalTime =
            args['maxArrivalTime'] as TimeOfDay? ?? TimeOfDay.now();
        final recurrence = args['recurrence'] as String? ?? 'none';
        final selectedCar = args['selectedCar'] as CarEntity;
        // ? ??
        //     CarEntity(
        //       company: 'null',
        //       model: 'null',
        //       color: 'null',
        //       numberPlate: '',
        //       mileage: 0,
        //       isVerified: false,
        //     );
        final availableSeats = args['availableSeats'] as int? ?? 1;
        final sameGenderOnly = args['sameGenderOnly'] as bool? ?? false;
        final paymentOption =
            args['paymentOption'] as List<String>? ?? ['Cash'];
        final routeDistance = args['routeDistance'] as String? ?? '12.9 km';
        final routeDuration = args['routeDuration'] as String? ?? '50 mins';

        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: D3DependencyInjection.init(),
            child: D3(
              fromDescription: fromDescription,
              fromPlaceId: fromPlaceID,
              toDescription: toDescription,
              toPlaceId: toPlaceID,
              routeCoords: routeCoords,
              date: date,
              time: time,
              maxArrivalTime: maxArrivalTime,
              recurrence: recurrence,
              selectedCar: selectedCar,
              availableSeats: availableSeats,
              sameGenderOnly: sameGenderOnly,
              paymentOption: paymentOption,
              routeDistance: routeDistance,
              routeDuration: routeDuration,
            ),
          ),
        );
      case active_rides_driver:
        final id =
            settings.arguments as String? ?? 'driver 86'; // Default to 'driver'
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
              providers: ActiveRideDi.init(),
              child: ActiveRidesDriverScreen(id: id)),
        );
      case '/booking_confirm_driver':
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: DriverBookingConfirmDependencyInjection.init(),
            child: BookingConfirmationDriverScreen(),
          ),
        );
      case ride_request_status:
        final id = settings.arguments as String? ??
            '6799bec18972ba4dbd99374a'; // Default ride ID
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ...PendingRideDi.init(),
              ...ApproveRidesDi.init(),
            ],
            child: RideRequestStatusScreen(rideId: id),
          ),
        );
      case r1Page:
        final arguments =
            settings.arguments as Map<String, dynamic>; // Access arguments
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: R1DependencyInjection.init(),
            child: R1Page(
              location: arguments['location'] as SourceAndDestModel,
            ),
          ),
        );
      case r2Page:
        final arguments = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: R2DependencyInjection.init(),
            child: R2Page(
              schedule: arguments['schedule'] as ScheduleModel,
              location: arguments['location'] as SourceAndDestModel,
            ),
          ),
        );
      case r3Page:
        final arguments = settings.arguments as Map<String, dynamic>;
        // final preferences = arguments['preference'] as PreferencesModel?;
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: R3DependancyInjection.init(),
            child: R3Page(
              schedule: arguments['schedule'] as ScheduleModel,
              preferences: arguments['preferences'] as PreferencesModel,
              location: arguments['location'] as SourceAndDestModel,
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
              matchingRides:
                  arguments['matchingRides'] as List<MatchingRideModel>,
              minPickupTime: arguments['minPickupTime'] as TimeOfDay,
              maxPickupTime: arguments['maxPickupTime'] as TimeOfDay,
              schedule: arguments['schedule'] as ScheduleModel,
            ),
          ),
        );
      case '/matching_rides':
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: MatchingDependencyInjection.init(),
            child: MatchingPage(
              schedule: arguments['schedule'] as ScheduleModel,
              minPickupTime: arguments['minPickupTime'] as TimeOfDay,
              maxPickupTime: arguments['maxPickupTime'] as TimeOfDay,
              rideRequestId: arguments['rideRequestId'] as String,
              initialMatchingRides:
                  arguments['matchingRides'] as List<MatchingRideModel>,
            ),
          ),
        );
      case sign_up:
        return MaterialPageRoute(
            builder: (_) => MultiProvider(
                providers: AuthDependencyInjection.init(),
                child: const SignUpScreen()));
      case emailVerification:
        return MaterialPageRoute(
            builder: (_) => MultiProvider(
                providers: AuthDependencyInjection.init(),
                child: const EmailVerificationScreen()));
      case create_user:
        return MaterialPageRoute(
            builder: (_) => MultiProvider(
                providers: CreateUserDependencyInjection.init(),
                child: CreateUserScreen()));
      case sign_in:
        return MaterialPageRoute(
            builder: (_) => MultiProvider(
                providers: SignInDependencyInjection.init(),
                child: const SignInPage()));
      case sos:
        return MaterialPageRoute(
            builder: (_) => MultiProvider(
                providers: SosDependencyInjection.init(),
                child: const SosScreen()));
      case emergency_contacts:
        return MaterialPageRoute(
            builder: (_) => MultiProvider(
                providers: SosDependencyInjection.init(),
                child: const ContactScreen()));
      case chat:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: ChatDependencyInjection.init(),
                child: ChatScreen()));
      case chat_detail:
        final user = settings.arguments as ChatUser;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: ChatDependencyInjection.init(),
                child: ChatDetailScreen(user: user)));
      case user_profile:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: UserProfileDi.init(), child: UserProfilePage()));
      case car:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: CarDependencyInjection.init(), child: CarScreen()));
      case ride_request_rider:
        return MaterialPageRoute(
            builder: (_) => MultiProvider(
                providers: RiderRequestsDi.init(),
                child: RiderRequestsScreen()));
      case static_page:
        final arguments = settings.arguments as Map<String, dynamic>;
        final rideData = arguments['rideData'] as RidestartDataModel;
        return MaterialPageRoute(
          builder: (_) => RideTrackingPage(rideData: rideData),
        );
      case ride_tracking:
        final arguments = settings.arguments as Map<String, dynamic>;
        final id = arguments['rideId'] as String;
        final coords = arguments['coords'] as List<List<double>>?;
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: RideStartDependencyInjection.init(),
            child: RideTrackingScreen(rideId: id, coords: coords),
          ),
        );
      case rider_view:
        final arguments = settings.arguments as Map<String, dynamic>;
        final id = arguments['rideId'] as String;
        final coords = arguments['coords'] as List<List<double>>?;
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: RideViewDependencyInjection.init(),
            child: RideViewScreen(rideId: id, coords: coords),
          ),
        );
      case rider_request_joins:
        final requestId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              ...RideRequestJoinDi.init(),
              ...MatchingDependencyInjection.init(),
            ],
            child: RiderRequestJoinsPage(rideRequestId: requestId),
          ),
        );
      case safety:
        return MaterialPageRoute(builder: (context) => SafetyFeaturesScreen());
      case before_ride:
        return MaterialPageRoute(builder: (context) => BeforeRideScreen());
      case protect:
        return MaterialPageRoute(builder: (context) => ProtectScreen());
      case user_verify:
        return MaterialPageRoute(builder: (context) => UserVerifyScreen());
      case route:
        return MaterialPageRoute(builder: (context) => RouteScreen());
      case safecontact:
        return MaterialPageRoute(builder: (context) => SafeContactScreen());

      case report:
        return MaterialPageRoute(builder: (context) => ReportScreen());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                appBar: AppBar(title: Text("Error")),
                body: const Center(child: Text("Unknown Route"))));
    }
  }
}
