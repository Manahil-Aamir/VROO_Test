import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  final SharedPreferences prefs;

  RoleBloc({required this.prefs}) : super(RoleInitial(_getInitialRole(prefs))) {
    on<SwitchRoleEvent>(_onSwitchRole);
  }

  static String _getInitialRole(SharedPreferences prefs) {
    return prefs.getString('user_role') ?? 'Driver';
  }

  void _onSwitchRole(SwitchRoleEvent event, Emitter<RoleState> emit) {
    final newRole = state.role == 'Driver' ? 'Rider' : 'Driver';
    prefs.setString('user_role', newRole);
    emit(RoleSwitched(newRole));
  }
}

abstract class RoleEvent extends Equatable {
  const RoleEvent();
}

class SwitchRoleEvent extends RoleEvent {
  @override
  List<Object> get props => [];
}

abstract class RoleState extends Equatable {
  final String role;
  const RoleState(this.role);

  @override
  List<Object> get props => [role];
}

class RoleInitial extends RoleState {
  const RoleInitial(super.role);
}

class RoleSwitched extends RoleState {
  const RoleSwitched(super.role);
}