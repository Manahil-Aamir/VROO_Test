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
  final Map<String, Map<String, dynamic>> lastMessagesInfo;
  final Map<String, Stream<Map<String, dynamic>?>> lastMessageStreams;

  ChatUsersLoaded(
    this.users,
    this.lastMessagesInfo,
    this.lastMessageStreams,
  );

  ChatUsersLoaded copyWith({
    List<ChatUser>? users,
    Map<String, Map<String, dynamic>>? lastMessagesInfo,
    Map<String, Stream<Map<String, dynamic>?>>? lastMessageStreams,
  }) {
    return ChatUsersLoaded(
      users ?? this.users,
      lastMessagesInfo ?? this.lastMessagesInfo,
      lastMessageStreams ?? this.lastMessageStreams,
    );
  }
}

/// Successfully loaded chat messages
class ChatMessagesLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool hasMore; // Flag to indicate if there are more messages to load

  ChatMessagesLoaded(this.messages, {this.hasMore = true});

  @override
  List<Object> get props => [messages, hasMore];
}

/// Successfully loaded chat info
class ChatInfoLoaded extends ChatState {
  final Map<String, dynamic> chatInfo;

  ChatInfoLoaded(this.chatInfo);

  @override
  List<Object> get props => [chatInfo];
}

/// Loading more messages state
class LoadingMoreMessages extends ChatState {}

/// Chat error state
class ChatError extends ChatState {
  final String message;

  ChatError(this.message);

  @override
  List<Object> get props => [message];
}
