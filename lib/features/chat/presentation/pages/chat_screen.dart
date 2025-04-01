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
import '../bloc/bloc/chat_bloc.dart';
import '../bloc/event/chat_event.dart';
import '../bloc/state/chat_state.dart';
import '../widgets/chat_list_item.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ChatUsersLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ChatBloc>().add(LoadChatUsers(roleState.role));
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          final chatId = _getChatId(currentUserId, user.id);
                          final lastMessageInfo = state.lastMessagesInfo[user.id] ?? {};

                          final lastMessage = lastMessageInfo['lastMessage'] ?? '';
                          final lastMessageTime = lastMessageInfo['lastMessageTime'] != null
                              ? _formatTime(DateTime.parse(lastMessageInfo['lastMessageTime']))
                              : '';
                          final unreadCount = lastMessageInfo['unreadCount_$currentUserId'] as int? ?? 0;

                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: ChatListItem(
                              user: user,
                              lastMessage: lastMessage,
                              lastMessageTime: lastMessageTime,
                              unreadCount: unreadCount,
                              onTap: () {
                                context.read<ChatBloc>().add(MarkMessagesAsReadEvent(chatId, currentUserId));
                                context.read<Navigation>().navigateTo('/chat_detail', arguments: user);
                              },
                            ),
                          );
                        },
                      ),
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
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 2),
    );
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

