import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/data_source/chat_firestore_data_source.dart';
import '../../../domain/usecases/get_chat_fcm_tokens.dart';
import '../../../domain/usecases/get_messages_usecase.dart';
import '../../../domain/usecases/messages_usecases.dart';
import '../../../domain/usecases/send_message_usecase.dart';
import '../event/chat_event.dart';
import '../state/chat_state.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatUsersUseCase getChatUsers;
  final StreamLastMessageInfoUseCase streamLastMessageInfo;
  final SendMessageUseCase sendMessage;
  final GetMessagesUseCase getMessages;
  final GetChatInfoUseCase getChatInfo;
  final ChatFirestoreDataSource firestoreDataSource;
  
  final Map<String, StreamSubscription<Map<String, dynamic>?>> _streamSubscriptions = {};
  final Map<String, Map<String, dynamic>> _lastMessagesCache = {};

  ChatBloc({
    required this.getChatUsers,
    required this.streamLastMessageInfo,
    required this.sendMessage,
    required this.getMessages,
    required this.getChatInfo,
    required this.firestoreDataSource,
  }) : super(ChatInitial()) {
    on<LoadChatUsers>(_onLoadChatUsers);
    on<UpdateLastMessageInfo>(_onUpdateLastMessageInfo);
    on<SendMessageEvent>(_onSendMessage);
    on<LoadChatMessages>(_onLoadChatMessages);
    on<LoadMoreMessages>(_onLoadMoreMessages);
    on<LoadChatInfo>(_onLoadChatInfo);
    on<MarkMessagesAsReadEvent>(_onMarkMessagesAsRead);
  }

  Future<void> _onLoadChatUsers(
    LoadChatUsers event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final users = await getChatUsers(event.role);
      if (users.isEmpty) {
        emit(ChatError('No users available for chat'));
      } else {
        // Cancel any existing subscriptions
        _cancelAllSubscriptions();

        final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
        
        // Initialize with cached data if available
        final initialLastMessagesInfo = Map<String, Map<String, dynamic>>.from(_lastMessagesCache);
        
        for (final user in users) {
          final chatId = _getChatId(currentUserId, user.id);
          final stream = streamLastMessageInfo(chatId);
          
          // Set up subscription for this user's chat
          _streamSubscriptions[user.id] = stream.listen((lastMessageInfo) {
            if (lastMessageInfo != null) {
              // Update cache
              _lastMessagesCache[user.id] = lastMessageInfo;
              add(UpdateLastMessageInfo(
                userId: user.id,
                lastMessageInfo: lastMessageInfo,
              ));
            }
          });

          // If we don't have cached data, get initial data
          if (!initialLastMessagesInfo.containsKey(user.id)) {
            final initialData = await stream.first;
            if (initialData != null) {
              initialLastMessagesInfo[user.id] = initialData;
              _lastMessagesCache[user.id] = initialData;
            }
          }
        }

        emit(ChatUsersLoaded(
          users: users,
          lastMessagesInfo: initialLastMessagesInfo,
        ));
      }
    } catch (e) {
      emit(ChatError('Failed to load users: ${e.toString()}'));
    }
  }

  void _onUpdateLastMessageInfo(
    UpdateLastMessageInfo event,
    Emitter<ChatState> emit,
  ) {
    if (state is ChatUsersLoaded) {
      final currentState = state as ChatUsersLoaded;
      emit(currentState.copyWith(
        lastMessagesInfo: Map<String, Map<String, dynamic>>.from(currentState.lastMessagesInfo)
          ..[event.userId] = event.lastMessageInfo,
      ));
    }
  }
  
  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await sendMessage(event.message);
    } catch (e) {
      emit(ChatError('Failed to send message: ${e.toString()}'));
    }
  }

  Future<void> _onLoadChatMessages(
    LoadChatMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      await emit.forEach(
        getMessages(event.chatId, event.limit),
        onData: (messages) {
          return ChatMessagesLoaded(messages, hasMore: messages.length >= event.limit);
        },
      );
    } catch (e) {
      emit(ChatError('Failed to load messages: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoreMessages(
    LoadMoreMessages event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatMessagesLoaded) return;
    
    final currentState = state as ChatMessagesLoaded;
    if (!currentState.hasMore) return;

    emit(LoadingMoreMessages());
    try {
      await emit.forEach(
        getMessages(event.chatId, event.limit),
        onData: (messages) {
          return ChatMessagesLoaded(
            messages,
            hasMore: messages.length >= event.limit,
          );
        },
      );
    } catch (e) {
      emit(ChatError('Failed to load more messages: ${e.toString()}'));
    }
  }

  Future<void> _onLoadChatInfo(
    LoadChatInfo event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final chatInfo = await getChatInfo(event.chatId);
      if (chatInfo != null) {
        emit(ChatInfoLoaded(chatInfo));
      }
    } catch (e) {
      emit(ChatError('Failed to load chat info: ${e.toString()}'));
    }
  }

  Future<void> _onMarkMessagesAsRead(
    MarkMessagesAsReadEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await firestoreDataSource.markMessageAsRead(event.chatId, event.userId);
    } catch (e) {
      // Don't emit error state for read receipts
      print('Error marking messages as read: $e');
    }
  }

  void _cancelAllSubscriptions() {
    for (final subscription in _streamSubscriptions.values) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();
  }

  @override
  Future<void> close() {
    _cancelAllSubscriptions();
    _lastMessagesCache.clear();
    return super.close();
  }

  String _getChatId(String user1, String user2) {
    List<String> sortedIds = [user1, user2]..sort();
    return sortedIds.join('_');
  }
}
