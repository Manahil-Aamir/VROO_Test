import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoadCurrentLocationEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class ClearPreferencesEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class LogoutEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class LoadUserEvent extends HomeEvent {
  @override
  List<Object?> get props => [];  
}
