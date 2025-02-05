import '../../../domain/entity/driver_schedule2_entity.dart';

abstract class CarPreferencesEvent {}

class LoadCarPreferencesEvent extends CarPreferencesEvent {}

class SaveCarPreferencesEvent extends CarPreferencesEvent {
  final CarPreferencesEntity preferences;

  SaveCarPreferencesEvent(this.preferences);
}
