import '../entity/chat_user.dart';

abstract class ChatRepository {
  Future<List<ChatUser>> getChatUsers(String role);
}
