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

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadChatMessages(widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.name)),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ChatMessagesLoaded) {
                  return ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.all(10),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final ChatMessage message = state.messages[index];
                      bool isSentByMe = message.senderId == widget.user.id;

                      return Align(
                        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: isSentByMe ? ThemeColors.primaryColor : ThemeColors.cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message.message,
                            style: TextStyle(color: isSentByMe ? Colors.white : Colors.black),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: ThemeColors.primaryColor),
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      final message = ChatMessage(
                        senderId: widget.user.id,
                        receiverId: widget.user.id,
                        message: _messageController.text.trim(),
                        timestamp: DateTime.now(),
                      );
                      context.read<ChatBloc>().add(SendMessageEvent(message));
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
