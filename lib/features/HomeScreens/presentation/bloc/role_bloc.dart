// features/home/presentation/bloc/role/role_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


class RoleBloc extends Bloc<RoleEvent, RoleState> {
  RoleBloc() : super(const RoleInitial('Driver')) {
    on<SwitchRoleEvent>(_onSwitchRole);
  }

  void _onSwitchRole(SwitchRoleEvent event, Emitter<RoleState> emit) {
    emit(RoleSwitched(state.role == 'Driver' ? 'Rider' : 'Driver'));
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