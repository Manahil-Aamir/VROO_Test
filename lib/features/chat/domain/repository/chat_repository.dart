import '../entity/chat_message.dart';
import '../entity/chat_user.dart';

abstract class ChatRepository {
  Future<List<ChatUser>> getChatUsers(String role);
  Future<void> sendMessage(ChatMessage message);
  Stream<List<ChatMessage>> getMessages(String chatId);
}
