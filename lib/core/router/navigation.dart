import 'package:flutter_bloc/flutter_bloc.dart';
import 'routes.dart';

class Navigation extends Cubit<String> {
  Navigation() : super(Routes.riderhome);

  void navigateTo(String routeName) {
    emit(routeName);
  }
}
