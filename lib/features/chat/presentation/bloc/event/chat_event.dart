import 'package:equatable/equatable.dart';
import '../../../domain/entity/chat_message.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Fetch chat users based on role
class LoadChatUsers extends ChatEvent {
  final String role;

  LoadChatUsers(this.role);

  @override
  List<Object> get props => [role];
}

/// Send a message event
class SendMessageEvent extends ChatEvent {
  final ChatMessage message;

  SendMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

/// Load chat messages for a conversation
class LoadChatMessages extends ChatEvent {
  final String chatId;

  LoadChatMessages(this.chatId);

  @override
  List<Object> get props => [chatId];
}
