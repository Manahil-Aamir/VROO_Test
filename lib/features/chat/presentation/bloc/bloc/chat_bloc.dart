import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_chat_fcm_tokens.dart';
import '../../../domain/usecases/send_message_usecase.dart';
import '../../../domain/usecases/get_messages_usecase.dart';
import '../event/chat_event.dart';
import '../state/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatUsersUseCase getChatUsers;
  final SendMessageUseCase sendMessage;
  final GetMessagesUseCase getMessages;

  ChatBloc({
    required this.getChatUsers,
    required this.sendMessage,
    required this.getMessages,
  }) : super(ChatInitial()) {
    on<LoadChatUsers>((event, emit) async {
      emit(ChatLoading());
      try {
        final users = await getChatUsers(event.role);
        if (users.isEmpty) {
          emit(ChatError('No users available for chat'));
        } else {
          emit(ChatUsersLoaded(users));
        }
      } catch (e) {
        print('Error loading chat users: $e');
        emit(ChatError('Failed to load users: ${e.toString()}'));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        await sendMessage(event.message);
        // We don't need to emit a new state here as the messages stream
        // will automatically update the UI when the new message is added
      } catch (e) {
        print('Error sending message: $e');
        emit(ChatError('Failed to send message: ${e.toString()}'));
      }
    });

    on<LoadChatMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        await emit.forEach(
          getMessages(event.chatId),
          onData: (messages) {
            return ChatMessagesLoaded(messages);
          },
          onError: (error, stackTrace) {
            print('Error in message stream: $error');
            print('Stack trace: $stackTrace');
            return ChatError('Failed to load messages: ${error.toString()}');
          },
        );
      } catch (e) {
        print('Error setting up message stream: $e');
        emit(ChatError('Failed to load messages: ${e.toString()}'));
      }
    });
  }

  String _getChatId(String user1, String user2) {
    List<String> sortedIds = [user1, user2]..sort();
    return sortedIds.join('_');
  }
}