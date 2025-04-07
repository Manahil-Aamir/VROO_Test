import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/color/color_theme.dart';
import '../../domain/entity/chat_user.dart';

class ChatListItem extends StatelessWidget {
  final ChatUser user;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          children: [
            // Smaller Profile Avatar
            CircleAvatar(
              radius: 20.r,
              backgroundColor: ThemeColors.primaryColor.withOpacity(0.2),
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.primaryColor,
                      fontSize: 14.sp,
                    ),
              ),
            ),
            SizedBox(width: 12.w),

            // Chat Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Time Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          user.name,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      if (lastMessageTime.isNotEmpty)
                        Text(
                          lastMessageTime,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                        ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Location Row (Source → Destination)
                  Row(
                    children: [
                      Icon(Icons.radio_button_checked, size: 14.w, color: ThemeColors.primaryColor),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          _getFirstThreeWords(user.source),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: ThemeColors.bodyTextColor,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Text(
                          '→',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.bodyTextColor.withOpacity(0.9),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _getFirstThreeWords(user.destination),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: ThemeColors.bodyTextColor,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.location_on, size: 14.w, color: ThemeColors.primaryColor),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Last message + unread badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage.isNotEmpty ? lastMessage : 'No messages yet',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: lastMessage.isNotEmpty
                                    ? ThemeColors.bodyTextColor
                                    : ThemeColors.bodyTextColor.withOpacity(0.5),
                                fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          margin: EdgeInsets.only(left: 8.w),
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: ThemeColors.primaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFirstThreeWords(String text) {
    final words = text.trim().split(' ');
    return words.length <= 3 ? text : '${words.take(3).join(' ')}...';
  }
}
