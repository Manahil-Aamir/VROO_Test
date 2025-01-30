import '../../../domain/entity/driver_schedule2_entity.dart';

abstract class CarPreferencesState {}

class CarPreferencesInitial extends CarPreferencesState {}

class CarPreferencesLoading extends CarPreferencesState {}

class CarPreferencesLoaded extends CarPreferencesState {
  final CarPreferencesEntity preferences;

  CarPreferencesLoaded(this.preferences);
}

class CarPreferencesError extends CarPreferencesState {
  final String message;

  CarPreferencesError(this.message);
}