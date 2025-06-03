import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/initials_circle_avatar.dart';
import '../../domain/entity/chat_message.dart';
import '../../domain/entity/chat_user.dart';
import '../bloc/bloc/chat_bloc.dart';
import '../bloc/event/chat_event.dart';
import '../bloc/state/chat_state.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatUser user;
  const ChatDetailScreen({super.key, required this.user});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String currentUserId;
  late String chatId;
  bool _isLoadingMore = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    chatId = _getChatId(currentUserId, widget.user.id);

    // Mark messages as read when opening chat
    context
        .read<ChatBloc>()
        .add(MarkMessagesAsReadEvent(chatId, currentUserId));

    // Load chat messages
    context.read<ChatBloc>().add(LoadChatMessages(chatId));

    // Setup scroll controller for loading more messages
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 0 && !_isLoadingMore) {
      // User has scrolled to the top, load more messages
      final state = context.read<ChatBloc>().state;
      if (state is ChatMessagesLoaded && state.hasMore) {
        setState(() {
          _isLoadingMore = true;
        });
        context.read<ChatBloc>().add(LoadMoreMessages(chatId));
      }
    }
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  String _getChatId(String user1, String user2) {
    List<String> sortedIds = [user1, user2]..sort();
    return sortedIds.join('_');
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _isSending = true;
    });

    final message = ChatMessage(
      senderId: currentUserId,
      receiverId: widget.user.id,
      message: _messageController.text.trim(),
      timestamp: DateTime.now(),
    );

    context.read<ChatBloc>().add(SendMessageEvent(message));

    _messageController.clear();
    setState(() {
      _isSending = false;
    });

    // Schedule a scroll to bottom after the message is sent
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollToBottom();
    });
  }

  String _formatMessageTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      // Today, show time
      return DateFormat('h:mm a').format(time);
    } else if (now.difference(time).inDays < 7) {
      // Within a week, show day and time
      return DateFormat('E, h:mm a').format(time);
    } else {
      // Show full date
      return DateFormat('MMM d, h:mm a').format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.h,
        backgroundColor: ThemeColors.primaryColor,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 15.r, // Slightly larger
              backgroundColor: ThemeColors.cardColor,
              child: Text(
                widget.user.name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.headlinesTextColor,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.user.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${DateFormat('dd-MM-yyyy').format(widget.user.date)}  ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 14.w, color: Colors.white70),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          '${_getFirstThreeWords(widget.user.source)} → ${_getFirstThreeWords(widget.user.destination)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              _showUserInfoBottomSheet(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatMessagesLoaded) {
                  // Reset loading more flag
                  if (_isLoadingMore) {
                    setState(() {
                      _isLoadingMore = false;
                    });
                  } else if (state.messages.isNotEmpty) {
                    // Only scroll to bottom for new messages, not when loading more
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                  }
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
                  final messages = state.messages;

                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 48.sp,
                            color: ThemeColors.primaryColorLight,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No messages yet',
                            style: AppStyles.getTextTheme().bodyLarge?.copyWith(
                                  color: ThemeColors.bodyTextColor,
                                ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Start the conversation!',
                            style:
                                AppStyles.getTextTheme().bodyMedium?.copyWith(
                                      color: ThemeColors.bodyTextColor
                                          .withOpacity(0.7),
                                    ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 20.h),
                        reverse:
                            false, // Set to true if you reverse the order of messages in your data source
                        itemCount: messages.length + (state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Show loading indicator at the top when loading more messages
                          if (state.hasMore && index == 0) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Center(
                                child: _isLoadingMore
                                    ? CircularProgressIndicator(
                                        color:
                                            ThemeColors.progressIndicatorColor,
                                        strokeWidth: 2.0,
                                      )
                                    : TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _isLoadingMore = true;
                                          });
                                          context
                                              .read<ChatBloc>()
                                              .add(LoadMoreMessages(chatId));
                                        },
                                        child: Text(
                                          'Load more messages',
                                          style: TextStyle(
                                            color: ThemeColors.primaryColor,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                              ),
                            );
                          }

                          // Adjust index if we have the load more button
                          final messageIndex =
                              state.hasMore ? index - 1 : index;
                          if (messageIndex < 0 ||
                              messageIndex >= messages.length) {
                            return SizedBox();
                          }

                          final message = messages[messageIndex];
                          final isMe = message.senderId == currentUserId;
                          final messageTime =
                              _formatMessageTime(message.timestamp);

                          // Check if we should show date separator
                          bool showDateSeparator = false;
                          if (messageIndex == 0) {
                            showDateSeparator = true;
                          } else {
                            final previousMessage = messages[messageIndex - 1];
                            final prevDate = previousMessage.timestamp;
                            final currentDate = message.timestamp;

                            if (prevDate.day != currentDate.day ||
                                prevDate.month != currentDate.month ||
                                prevDate.year != currentDate.year) {
                              showDateSeparator = true;
                            }
                          }

                          return Column(
                            children: [
                              if (showDateSeparator)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: ThemeColors.cardColor
                                            .withOpacity(0.7),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Text(
                                        _getDateSeparator(message.timestamp),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: ThemeColors.bodyTextColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: 8.h,
                                    left: isMe ? 64.w : 0,
                                    right: isMe ? 0 : 64.w,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? ThemeColors.primaryColor
                                            .withOpacity(0.85)
                                        : ThemeColors.cardColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.r),
                                      topRight: Radius.circular(16.r),
                                      bottomLeft:
                                          Radius.circular(isMe ? 16.r : 4.r),
                                      bottomRight:
                                          Radius.circular(isMe ? 4.r : 16.r),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.message,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: isMe
                                              ? Colors.white
                                              : ThemeColors.primaryColorDark,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            messageTime,
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: isMe
                                                  ? Colors.white70
                                                  : ThemeColors.bodyTextColor
                                                      .withOpacity(0.7),
                                            ),
                                          ),
                                          if (isMe) ...[
                                            SizedBox(width: 4.w),
                                            Icon(
                                              Icons.check_circle,
                                              size: 12.sp,
                                              color: Colors.white70,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      if (_isLoadingMore)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            color: ThemeColors.scaffoldBackgroundColor
                                .withOpacity(0.8),
                            child: Center(
                              child: Text(
                                'Loading more messages...',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ThemeColors.bodyTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                } else if (state is ChatError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.sp,
                          color: ThemeColors.accentColor,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Error loading messages',
                          style:
                              AppStyles.getTextTheme().headlineSmall?.copyWith(
                                    color: ThemeColors.accentColor,
                                  ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: AppStyles.getTextTheme().bodyMedium?.copyWith(
                                color: ThemeColors.bodyTextColor,
                              ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<ChatBloc>()
                                .add(LoadChatMessages(chatId));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColors.buttonColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Retry',
                            style:
                                TextStyle(color: ThemeColors.buttonTextColor),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Default loading state
                return Center(
                  child: CircularProgressIndicator(
                    color: ThemeColors.progressIndicatorColor,
                  ),
                );
              },
            ),
          ),

          // Message input area
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: ThemeColors.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    color: ThemeColors.primaryColor,
                    onPressed: () {
                      // Attachment functionality (future implementation)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Attachments coming soon')),
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                            color: ThemeColors.bodyTextColor.withOpacity(0.6)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: ThemeColors.scaffoldBackgroundColor,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 10.h),
                      ),
                      style: TextStyle(color: ThemeColors.bodyTextColor),
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 5,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: _isSending
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            )
                          : Icon(Icons.send),
                      color: Colors.white,
                      onPressed: _isSending ? null : _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFirstThreeWords(String text) {
    List<String> words = text.split(' ');
    return words.length <= 3 ? text : '${words.take(3).join(' ')}...';
  }

  String _getDateSeparator(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    } else if (now.difference(date).inDays < 7) {
      // Within a week
      return DateFormat('EEEE').format(date); // e.g., "Monday"
    } else {
      return DateFormat('MMM d, yyyy').format(date); // e.g., "Jan 5, 2023"
    }
  }

void _showUserInfoBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: ThemeColors.primaryColorDark, // Changed to primary color dark
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Drag Handle
            Center(
              child: Container(
                height: 5.h,
                width: 40.w,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: ThemeColors.dividerColor,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),

            /// User Profile Section
            Row(
              children: [
                /// Profile Icon - Using your InitialsCircleAvatar
                InitialsCircleAvatar(
                  initials: widget.user.name[0].toUpperCase(),
                  radius: 30,
                ),
                SizedBox(width: 16.w),

                /// Name & ID
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Name (Handles overflow)
                      Text(
                        widget.user.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: ThemeColors.buttonTextColor, // Changed to button text color
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 4.h),
                      // Added date and time of ride
                      Text(
                        'Ride on ${DateFormat('MMM d, yyyy').format(widget.user.date)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              color: ThemeColors.buttonTextColor.withOpacity(0.8),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(
              thickness: 1,
              color: ThemeColors.dividerColor.withOpacity(0.6)),
            SizedBox(height: 8.h),

            /// Location Information
            _infoItem(Icons.place_outlined, 'From', widget.user.source),
            SizedBox(height: 12.h),
            _infoItem(Icons.location_on_outlined, 'To', widget.user.destination),
            SizedBox(height: 24.h),
          ],
        ),
      );
    },
  );
}

/// Updated helper method to handle location display with color changes
Widget _infoItem(IconData icon, String title, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: ThemeColors.primaryColor, size: 20.sp), // Kept primary color for icon
      SizedBox(width: 8.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: ThemeColors.primaryColor, // Kept primary color for "From/To" text
                  ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    color: ThemeColors.buttonTextColor, // Changed to button text color
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ],
  );
}
  /// Helper method to handle location display
  // Widget _infoItem(IconData icon, String title, String value) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Icon(icon, color: ThemeColors.primaryColor, size: 20.sp),
  //       SizedBox(width: 12.w),
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               title,
  //               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 14.sp,
  //                     color: ThemeColors.bodyTextColor.withOpacity(0.8),
  //                   ),
  //             ),
  //             SizedBox(height: 2.h),
  //             Text(
  //               value,
  //               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                     fontSize: 13.sp,
  //                     color: ThemeColors.headlinesTextColor,
  //                   ),
  //               maxLines: 2, // Allows up to 2 lines
  //               overflow: TextOverflow.ellipsis, // Truncates text if needed
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

}
