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

class ChatUsersLoaded extends ChatState {
  final List<ChatUser> users;
  final Map<String, Map<String, dynamic>> lastMessagesInfo;

  ChatUsersLoaded({
    required this.users,
    required this.lastMessagesInfo,
  });

  ChatUsersLoaded copyWith({
    List<ChatUser>? users,
    Map<String, Map<String, dynamic>>? lastMessagesInfo,
  }) {
    return ChatUsersLoaded(
      users: users ?? this.users,
      lastMessagesInfo: lastMessagesInfo ?? this.lastMessagesInfo,
    );
  }

  // Helper method to get sorted users with duplicates removed
  List<ChatUser> get sortedUsers {
    // Create a map of users by ID to ensure uniqueness
    final userMap = <String, ChatUser>{};
    for (final user in users) {
      userMap[user.id] = user;
    }
    
    // Get the unique user list
    final uniqueUsers = userMap.values.toList();
    
    // Sort by last message time
    uniqueUsers.sort((a, b) {
      final aTime = lastMessagesInfo[a.id]?['lastMessageTime'] ?? '';
      final bTime = lastMessagesInfo[b.id]?['lastMessageTime'] ?? '';
      
      if (aTime.isNotEmpty && bTime.isNotEmpty) {
        return DateTime.parse(bTime).compareTo(DateTime.parse(aTime));
      } else if (aTime.isNotEmpty) {
        return -1;
      } else if (bTime.isNotEmpty) {
        return 1;
      }
      return a.name.compareTo(b.name); // Fallback to alphabetical sort by name
    });
    
    return uniqueUsers;
  }

  @override
  List<Object> get props => [users, lastMessagesInfo];
}

// Successfully loaded chat messages
class ChatMessagesLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool hasMore; // Flag to indicate if there are more messages to load

  ChatMessagesLoaded(this.messages, {this.hasMore = true});

  @override
  List<Object> get props => [messages, hasMore];
}

class ChatEmpty extends ChatState {
  final String message;
  
  ChatEmpty({required this.message});

  @override
  List<Object> get props => [message];
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
