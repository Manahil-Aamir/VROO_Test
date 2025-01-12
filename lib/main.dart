import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';
import 'features/driver_booking/dependency_injection/location_selection_di.dart';

void main() async {
  //await dotenv.load(fileName: "assets/.env");
  DependencyInjector.setup();
  runApp(const App());
}
