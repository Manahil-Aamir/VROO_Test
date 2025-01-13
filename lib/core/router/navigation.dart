import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'routes.dart';

class Navigation extends Cubit<String> {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Navigation() : super(Routes.ui);

  void navigateTo(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}
