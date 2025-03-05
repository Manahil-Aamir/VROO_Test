import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../presentation/bloc/role_bloc.dart';

class RoleDependencyInjection {
  static Future<List<BlocProvider>> init() async {
    final prefs = await SharedPreferences.getInstance();
    return [
      BlocProvider<RoleBloc>(
        create: (_) => RoleBloc(prefs: prefs),
        lazy: false,
      ),
    ];
  }
}