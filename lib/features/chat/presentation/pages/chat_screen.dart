import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../HomeScreens/presentation/bloc/role_bloc.dart';
import '../../domain/usecases/get_chat_fcm_tokens.dart';
import '../bloc/bloc/chat_bloc.dart';
import '../bloc/event/chat_event.dart';
import '../bloc/state/chat_state.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(heading: 'Chats'),
      body: BlocBuilder<RoleBloc, RoleState>(
        builder: (context, roleState) {
          if (roleState is RoleInitial || roleState is RoleSwitched) {
            final role = roleState.role; // Get the role from RoleBloc

            return BlocProvider(
              create: (context) =>
                  ChatBloc(getChatUsers: context.read<GetChatUsersUseCase>())
                    ..add(LoadChatUsers(role)), // Use role here
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ThemeColors.progressIndicatorColor,
                      ),
                    );
                  } else if (state is ChatLoaded) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return Card(
                          color: ThemeColors.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          margin: EdgeInsets.only(bottom: 12.h),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                            leading: CircleAvatar(
                              backgroundColor: ThemeColors.primaryColorLight,
                              child: Icon(Icons.person, color: ThemeColors.headlinesTextColor),
                            ),
                            title: Text(
                              user.name,
                              style: AppStyles.getTextTheme().headlineMedium,
                            ),
                            subtitle: Text(
                              '${user.source} → ${user.destination}',
                              style: AppStyles.getTextTheme().bodySmall?.copyWith(
                                color: ThemeColors.bodyTextColor,
                              ),
                            ),
                            trailing: Icon(
                              Icons.chat,
                              color: ThemeColors.primaryColor,
                            ),
                            onTap: () {
                              // Navigate to chat screen
                            },
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
                              context.read<ChatBloc>().add(LoadChatUsers(role));
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
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 2,
      ),
    );
  }
}
