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
        emit(ChatUsersLoaded(users));
      } catch (e) {
        emit(ChatError('Failed to load users'));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        await sendMessage(event.message);
      } catch (e) {
        emit(ChatError('Failed to send message'));
      }
    });

    on<LoadChatMessages>((event, emit) async {
      emit(ChatLoading());
      final messagesStream = getMessages(event.chatId);
      await emit.forEach(messagesStream, onData: (messages) {
        return ChatMessagesLoaded(messages);
      });
    });
  }
}
