import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/app.dart';
import 'routes.dart';

class Navigation extends Cubit<String> {
  Navigation() : super(Routes.ui);

  void navigateTo(String routeName, {Object? arguments}) {
    Navigator.of(navigationContext!).pushNamed(routeName, arguments: arguments);
  }
}

// No changes to `navigationContext` in this class
