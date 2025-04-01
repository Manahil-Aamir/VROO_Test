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
  final int limit;

  LoadChatMessages(this.chatId, {this.limit = 20});

  @override
  List<Object> get props => [chatId, limit];
}

/// Load more messages (for pagination)
class LoadMoreMessages extends ChatEvent {
  final String chatId;
  final int limit;

  LoadMoreMessages(this.chatId, {this.limit = 20});

  @override
  List<Object> get props => [chatId, limit];
}

/// Load chat info (last message, participants)
class LoadChatInfo extends ChatEvent {
  final String chatId;

  LoadChatInfo(this.chatId);

  @override
  List<Object> get props => [chatId];
}

/// Mark messages as read
class MarkMessagesAsReadEvent extends ChatEvent {
  final String chatId;
  final String userId;

  MarkMessagesAsReadEvent(this.chatId, this.userId);

  @override
  List<Object> get props => [chatId, userId];
}

// chat_event.dart
class UpdateLastMessageInfo extends ChatEvent {
  final String userId;
  final Map<String, dynamic> lastMessageInfo;

  UpdateLastMessageInfo({required this.userId, required this.lastMessageInfo});

  @override
  List<Object> get props => [userId, lastMessageInfo];
}
