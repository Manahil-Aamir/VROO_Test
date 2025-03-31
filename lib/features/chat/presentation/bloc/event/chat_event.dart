import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadChatUsers extends ChatEvent {
  final String role;

  LoadChatUsers(this.role);

  @override
  List<Object> get props => [role];
}
