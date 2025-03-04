import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/bloc/role_bloc.dart';

class RoleDependencyInjection {
  static List<BlocProvider> init() {
    return [
      BlocProvider<RoleBloc>(
        create: (_) => RoleBloc(),
        lazy: false, // Initialize immediately
      ),
    ];
  }
}