import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/router/navigation.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../HomeScreens/presentation/bloc/role_bloc.dart';
import '../../domain/entity/chat_user.dart';
import '../bloc/bloc/chat_bloc.dart';
import '../bloc/event/chat_event.dart';
import '../bloc/state/chat_state.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: appBar(heading: 'Chats'),
      body: BlocBuilder<RoleBloc, RoleState>(
        builder: (context, roleState) {
          if (roleState is RoleInitial || roleState is RoleSwitched) {
            return BlocProvider(
              create: (context) => ChatBloc(
                getChatUsers: context.read(),
                streamLastMessageInfo: context.read(),
                sendMessage: context.read(),
                getMessages: context.read(),
                getChatInfo: context.read(),
                firestoreDataSource: context.read(),
              )..add(LoadChatUsers(roleState.role)),
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  if (state is ChatUsersLoaded) {
                    for (final entry in state.lastMessageStreams.entries) {
                      final userId = entry.key;
                      final stream = entry.value;
                      stream.listen((lastMessageInfo) {
                        if (lastMessageInfo != null) {
                          context.read<ChatBloc>().add(UpdateLastMessageInfo(
                            userId: userId,
                            lastMessageInfo: lastMessageInfo,
                          ));
                        }
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
                  } else if (state is ChatUsersLoaded) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final ChatUser user = state.users[index];
                        final chatId = _getChatId(currentUserId, user.id);
                        
                        final lastMessageInfo = state.lastMessagesInfo[user.id] ?? {};
                        final lastMessage = lastMessageInfo['lastMessage'] ?? '';
                        final lastMessageTime = lastMessageInfo['lastMessageTime'] != null
                            ? _formatTime(DateTime.parse(lastMessageInfo['lastMessageTime']))
                            : '';
                        final unreadCount = lastMessageInfo['unreadCount_$currentUserId'] as int? ?? 0;

                        return Card(
                          color: ThemeColors.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          margin: EdgeInsets.only(bottom: 12.h),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () {
                              context.read<ChatBloc>().add(MarkMessagesAsReadEvent(chatId, currentUserId));
                              context.read<Navigation>().navigateTo('/chat_detail', arguments: user);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // User name and unread count
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        user.name,
                                        style: AppStyles.getTextTheme().headlineMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (unreadCount > 0)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: ThemeColors.primaryColor,
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Text(
                                            unreadCount.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  
                                  SizedBox(height: 8.h),

                                  // Route details
                                  Text(
                                    '${_getFirstThreeWords(user.source)} → ${_getFirstThreeWords(user.destination)}',
                                    style: AppStyles.getTextTheme().bodySmall?.copyWith(
                                      color: ThemeColors.bodyTextColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  
                                  SizedBox(height: 8.h),

                                  // Last message and timestamp
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          lastMessage.isNotEmpty ? lastMessage : 'No messages yet',
                                          style: AppStyles.getTextTheme().bodySmall?.copyWith(
                                            color: lastMessage.isNotEmpty 
                                                ? ThemeColors.bodyTextColor 
                                                : ThemeColors.bodyTextColor.withOpacity(0.6),
                                            fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (lastMessageTime.isNotEmpty)
                                        Text(
                                          lastMessageTime,
                                          style: AppStyles.getTextTheme().bodySmall?.copyWith(
                                            color: ThemeColors.bodyTextColor.withOpacity(0.6),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: AppStyles.getTextTheme().headlineMedium?.copyWith(
                              color: ThemeColors.accentColor,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ChatBloc>().add(LoadChatUsers(roleState.role));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeColors.buttonColor,
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              'Retry',
                              style: AppStyles.getTextTheme().labelLarge?.copyWith(
                                color: ThemeColors.buttonTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: ThemeColors.progressIndicatorColor,
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 2),
    );
  }

  String _getFirstThreeWords(String text) {
    List<String> words = text.split(' ');
    if (words.length <= 3) return text;
    return '${words.take(3).join(' ')}...';
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day && time.month == now.month && time.year == now.year) {
      return DateFormat('h:mm a').format(time);
    }
    return DateFormat('MM/dd/yy').format(time);
  }

  String _getChatId(String user1, String user2) {
    List<String> sortedIds = [user1, user2]..sort();
    return sortedIds.join('_');
  }
}
