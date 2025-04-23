// user_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/data_source/user_preference.dart';
import '../../data/model/user_model.dart';

// Events
abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetUserEvent extends UserEvent {
  final UserModel user;

  SetUserEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

// States
abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;

  UserLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

// BLoC
// user_bloc.dart
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<SetUserEvent>((event, emit) {
      emit(UserLoaded(user: event.user));
    });
    
    // Load user from preferences when bloc is created
    _loadInitialUser();
  }

  Future<void> _loadInitialUser() async {
    final user = await UserPreferences.getUser();
    if (user != null) {
      add(SetUserEvent(user: user));
    }
  }
}
