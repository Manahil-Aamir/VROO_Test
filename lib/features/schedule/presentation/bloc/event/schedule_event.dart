import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class LoadSchedulesEvent extends ScheduleEvent {
  final String role;
  
  const LoadSchedulesEvent({required this.role});
  
  @override
  List<Object> get props => [role];
}

class RefreshSchedulesEvent extends ScheduleEvent {
  final String role;
  
  const RefreshSchedulesEvent({required this.role});
  
  @override
  List<Object> get props => [role];
}

class DeleteScheduleEvent extends ScheduleEvent {
  final String id;
  final String role;
  
  const DeleteScheduleEvent({required this.id, required this.role});
  
  @override
  List<Object> get props => [id];
}
