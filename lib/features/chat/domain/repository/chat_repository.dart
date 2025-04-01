import '../entity/chat_message.dart';
import '../entity/chat_user.dart';

abstract class ChatRepository {
  Future<List<ChatUser>> getChatUsers(String role);
  Future<void> sendMessage(ChatMessage message);
  Stream<List<ChatMessage>> getMessages(String chatId, [int limit = 20]);
  Future<Map<String, dynamic>?> getChatInfo(String chatId);
  Stream<Map<String, dynamic>?> streamLastMessageInfo(String chatId);
}
