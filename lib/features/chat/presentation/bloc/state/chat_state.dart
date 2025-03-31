import 'package:equatable/equatable.dart';
import '../../../domain/entity/chat_message.dart';
import '../../../domain/entity/chat_user.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object> get props => [];
}

/// Initial state
class ChatInitial extends ChatState {}

/// Loading state for fetching users or messages
class ChatLoading extends ChatState {}

/// Successfully loaded chat users
class ChatUsersLoaded extends ChatState {
  final List<ChatUser> users;

  ChatUsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

/// Successfully loaded chat messages
class ChatMessagesLoaded extends ChatState {
  final List<ChatMessage> messages;

  ChatMessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

/// Chat error state
class ChatError extends ChatState {
  final String message;

  ChatError(this.message);

  @override
  List<Object> get props => [message];
}
