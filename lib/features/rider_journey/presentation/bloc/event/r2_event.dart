import 'package:flutter/material.dart';
import '../../../data/model/preferences_model.dart';

abstract class R2Event {}

class SavePreferenceEvent extends R2Event {
  final PreferencesModel preference;

  SavePreferenceEvent(this.preference);
}

class LoadPreferenceEvent extends R2Event {
  LoadPreferenceEvent();
}

class TogglePreferenceEvent extends R2Event {
  final String preferenceKey; // "sameGender" or "walk"

  TogglePreferenceEvent(this.preferenceKey);
}

class UpdatePreferenceEvent extends R2Event {
  final bool? sameGender;
  final bool? walk;

  UpdatePreferenceEvent({
    this.sameGender,
    this.walk,
  });

  List<Object?> get props => [sameGender, walk];
}

class ResetStateEvent extends R2Event {
  List<Object?> get props => [];
}
