import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/chat_message_model.dart';

abstract class ChatFirestoreDataSource {
  Future<void> sendMessage(ChatMessageModel message);
  Stream<List<ChatMessageModel>> getMessages(String chatId);
}

class ChatFirestoreDataSourceImpl implements ChatFirestoreDataSource {
  final FirebaseFirestore firestore;

  ChatFirestoreDataSourceImpl(this.firestore);

  @override
  Stream<List<ChatMessageModel>> getMessages(String chatId) {
    print('DEBUG: Getting messages for chat ID: $chatId');
    
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .handleError((error) => print('Firestore Error: $error'))
        .map((snapshot) {
          print('DEBUG: Received ${snapshot.docs.length} messages');
          return snapshot.docs
              .map((doc) {
                print('Message Data: ${doc.data()}');
                return ChatMessageModel.fromJson(doc.data());
              })
              .toList();
        });
  }

  @override
  Future<void> sendMessage(ChatMessageModel message) async {
    final chatId = _getChatId(message.senderId, message.receiverId);
    print('DEBUG: Sending message to chat ID: $chatId');
    
    try {
      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toJson());
      print('DEBUG: Message sent successfully');
    } catch (e) {
      print('Error sending message: $e');
      throw e;
    }
  }

  String _getChatId(String user1, String user2) {
    final sortedIds = [user1, user2]..sort();
    return sortedIds.join('_');
  }
}
