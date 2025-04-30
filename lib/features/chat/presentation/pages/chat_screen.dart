import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vroo_test/shared/widgets/appbar_no_icon.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../core/utils/exit_dialouge_util.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../HomeScreens/presentation/bloc/role_bloc.dart';
import '../bloc/bloc/chat_bloc.dart';
import '../bloc/event/chat_event.dart';
import '../bloc/state/chat_state.dart';
import '../widgets/chat_list_item.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await DialogUtil.showExitDialog(context);
        if (exitApp) {
          SystemNavigator.pop(); // Closes the app
        }
        return false; // Prevents the default back action
      },
      child: Scaffold(
        appBar: AppBarNoIcon(heading: 'Chats'),
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
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ChatEmpty) {
                      return _buildEmptyState(context);
                    }
                      else if (state is ChatUsersLoaded) {
                      if (state.users.isEmpty) {
                        return _buildEmptyState(context);
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<ChatBloc>()
                              .add(LoadChatUsers(roleState.role));
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          itemCount: state.users.length,
                          itemBuilder: (context, index) {
                            final user = state.sortedUsers[index];
                            final chatId = _getChatId(
                                FirebaseAuth.instance.currentUser?.uid ?? '',
                                user.id);
                            final lastMessageInfo =
                                state.lastMessagesInfo[user.id] ?? {};

                            final lastMessage =
                                lastMessageInfo['lastMessage'] ?? '';
                            final lastMessageTime =
                                lastMessageInfo['lastMessageTime'] != null
                                    ? _formatTime(DateTime.parse(
                                        lastMessageInfo['lastMessageTime']))
                                    : '';
                            final unreadCount = lastMessageInfo[
                                        'unreadCount_${FirebaseAuth.instance.currentUser?.uid}']
                                    as int? ??
                                0;

                            return ChatListItem(
                              user: user,
                              lastMessage: lastMessage,
                              lastMessageTime: lastMessageTime,
                              unreadCount: unreadCount,
                              onTap: () {
                                context.read<ChatBloc>().add(
                                    MarkMessagesAsReadEvent(
                                        chatId,
                                        FirebaseAuth
                                                .instance.currentUser?.uid ??
                                            ''));
                                context.read<Navigation>().navigateTo(
                                    '/chat_detail',
                                    arguments: user);
                              },
                            );
                          },
                        ),
                      );
                    } else if (state is ChatError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/error.png',
                              width: 300.w,
                              height: 300.h,
                              fit: BoxFit.contain,
                            ),
                            // SizedBox(height: 16.h),
                            // Padding(
                            //   padding: EdgeInsets.symmetric(horizontal: 24.w),
                            //   child: Text(
                            //     'Failed to load profile information. Please try again later.',
                            //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            //       color: ThemeColors.accentColor,
                            //       fontSize: 14.sp,
                            //     ),
                            //     textAlign: TextAlign.center,
                            //   ),
                            // ),
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
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    print('No chats available');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64.sp,
            color: Colors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            'No chats available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ThemeColors.bodyTextColor,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please create a ride to start chatting',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.bodyTextColor.withOpacity(0.7),
                ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              // Navigate to create ride screen
              context.read<Navigation>().navigateTo('/location');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text(
              'Create Ride',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return DateFormat('h:mm a').format(time);
    }
    return DateFormat('MM/dd/yy').format(time);
  }

  String _getChatId(String user1, String user2) {
    List<String> sortedIds = [user1, user2]..sort();
    return sortedIds.join('_');
  }
}
