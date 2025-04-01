import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chat_message_model.dart';

abstract class ChatFirestoreDataSource {
  Future<void> sendMessage(ChatMessageModel message);
  Stream<List<ChatMessageModel>> getMessages(String chatId, [int limit = 20]);
  Future<void> updateLastMessage(ChatMessageModel message);
  Future<Map<String, dynamic>?> getChatInfo(String chatId);
  Future<void> markMessageAsRead(String chatId, String userId);
  Stream<Map<String, dynamic>?> streamLastMessageInfo(String chatId);
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
      
      // Update last message info
      await updateLastMessage(message);
      
      print('Message sent successfully');
    } catch (e) {
      print('Error sending message: $e');
      throw e;
    }
  }

  @override
  Future<void> updateLastMessage(ChatMessageModel message) async {
    String chatId = _getChatId(message.senderId, message.receiverId);
    
    // Get current unread count if exists
    final chatDoc = await firestore.collection('chats').doc(chatId).get();
    int currentUnreadCount = 0;
    
    if (chatDoc.exists) {
      final data = chatDoc.data();
      if (data != null && data.containsKey('unreadCount_${message.receiverId}')) {
        currentUnreadCount = data['unreadCount_${message.receiverId}'] as int;
      }
    }
    
    await firestore.collection('chats').doc(chatId).set({
      'lastMessage': message.message,
      'lastMessageTime': message.timestamp.toIso8601String(), // Store as ISO string for consistency
      'participants': [message.senderId, message.receiverId],
      'unreadCount_${message.receiverId}': currentUnreadCount + 1, // Increment unread count for receiver
      'lastSender': message.senderId, // Track who sent the last message
    }, SetOptions(merge: true));

    print('Updated last message for chatId: $chatId');
    print('Last message details: ${message.toJson()}');
  }

  @override
  Stream<Map<String, dynamic>?> streamLastMessageInfo(String chatId) {
    return firestore.collection('chats').doc(chatId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return snapshot.data()!..['chatId'] = chatId; // Include chatId in the data
    });
  }

  @override
  Future<void> markMessageAsRead(String chatId, String userId) async {
    try {
      await firestore.collection('chats').doc(chatId).update({
        'unreadCount_$userId': 0,
      });
      print('Marked messages as read for user: $userId in chat: $chatId');
    } catch (e) {
      print('Error marking messages as read: $e');
      throw e;
    }
  }

  @override
  Future<Map<String, dynamic>?> getChatInfo(String chatId) async {
    try {
      final docSnapshot = await firestore.collection('chats').doc(chatId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } catch (e) {
      print('Error getting chat info: $e');
      throw e;
    }
  }

  @override
  Stream<List<ChatMessageModel>> getMessages(String chatId, [int limit = 20]) {
    print('Getting messages for chatId: $chatId, limit: $limit');
    
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true) // Get newest first for pagination
        .limit(limit)
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
          
          // Reverse the list to get oldest first for display
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          
          print('Retrieved ${messages.length} messages');
          return messages;
        });
  }

  String _getChatId(String user1, String user2) {
    List<String> sortedIds = [user1, user2]..sort();
    return sortedIds.join('_');
  }
}
