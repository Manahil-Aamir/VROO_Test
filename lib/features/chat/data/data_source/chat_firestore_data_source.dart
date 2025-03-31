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
  Future<void> sendMessage(ChatMessageModel message) async {
    String chatId = _getChatId(message.senderId, message.receiverId);
    
    print('Sending message to chatId: $chatId');
    print('Message details: ${message.toJson()}');

    try {
      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toJson());
      print('Message sent successfully');
    } catch (e) {
      print('Error sending message: $e');
      throw e;
    }
  }

  @override
  Stream<List<ChatMessageModel>> getMessages(String chatId) {
    print('Getting messages for chatId: $chatId');
    
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false) // Changed to false to get oldest first
        .snapshots()
        .map((snapshot) {
          final messages = snapshot.docs
              .map((doc) {
                try {
                  return ChatMessageModel.fromJson(doc.data());
                } catch (e) {
                  print('Error parsing message: $e');
                  return null;
                }
              })
              .where((message) => message != null)
              .cast<ChatMessageModel>()
              .toList();
          
          print('Retrieved ${messages.length} messages');
          return messages;
        });
  }

  String _getChatId(String user1, String user2) {
    List<String> sortedIds = [user1, user2]..sort();
    return sortedIds.join('_');
  }
}