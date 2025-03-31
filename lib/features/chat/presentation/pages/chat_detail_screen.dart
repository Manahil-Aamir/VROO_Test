import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../domain/entity/chat_message.dart';
import '../../domain/entity/chat_user.dart';
import '../bloc/bloc/chat_bloc.dart';
import '../bloc/event/chat_event.dart';
import '../bloc/state/chat_state.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatUser user;
  ChatDetailScreen({required this.user});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String currentUserId;
  late String chatId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    chatId = _getChatId(currentUserId, widget.user.id);
    context.read<ChatBloc>().add(LoadChatMessages(chatId));
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getChatId(String user1, String user2) {
    List<String> sortedIds = [user1, user2]..sort();
    return sortedIds.join('_');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
        backgroundColor: ThemeColors.primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatMessagesLoaded) {
                  // Scroll to bottom when new messages arrive
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ThemeColors.progressIndicatorColor,
                    ),
                  );
                } else if (state is ChatMessagesLoaded) {
                  if (state.messages.isEmpty) {
                    return Center(
                      child: Text(
                        'No messages yet. Start a conversation!',
                        style: AppStyles.getTextTheme().bodyLarge,
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(10.r),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final ChatMessage message = state.messages[index];
                      bool isSentByMe = message.senderId == currentUserId;

                      return Align(
                        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10.r),
                          margin: EdgeInsets.symmetric(vertical: 5.h),
                          constraints: BoxConstraints(maxWidth: 250.w),
                          decoration: BoxDecoration(
                            color: isSentByMe ? ThemeColors.primaryColor : ThemeColors.cardColor,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(
                                  color: isSentByMe ? Colors.white : Colors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _formatTime(message.timestamp),
                                style: TextStyle(
                                  color: isSentByMe ? Colors.white70 : Colors.black54,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return Center(
                    child: Text(
                      'Error loading messages: ${state.message}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.r),
                        borderSide: BorderSide(color: ThemeColors.primaryColor),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    _sendMessage();
                    // Scroll to bottom after sending message
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: ThemeColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final message = ChatMessage(
        senderId: currentUserId,
        receiverId: widget.user.id,
        message: _messageController.text.trim(),
        timestamp: DateTime.now(),
      );
      context.read<ChatBloc>().add(SendMessageEvent(message));
      _messageController.clear();
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
