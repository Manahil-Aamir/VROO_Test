import 'package:equatable/equatable.dart';

import '../../../domain/entity/chat_user.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatUser> users;

  ChatLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);

  @override
  List<Object> get props => [message];
}
