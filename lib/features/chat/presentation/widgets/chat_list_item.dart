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
    return Card(
      elevation: 2,
      color: ThemeColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          child: Row(
            children: [
              // User Avatar
              CircleAvatar(
                radius: 26.r,
                backgroundColor: ThemeColors.primaryColor.withOpacity(0.2),
                child: Text(
                  user.name[0].toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.primaryColor,
                      ),
                ),
              ),

              SizedBox(width: 14.w),

              // Chat Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & Unread Count
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
                        if (unreadCount > 0)
                          Container(
                            width: 23.w,
                            height: 23.h,
                            decoration: BoxDecoration(
                              color: ThemeColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              unreadCount.toString(),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                  ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // Route Information
                    Row(
                      children: [
                        // Source
                        Icon(Icons.radio_button_checked, size: 14.w, color: ThemeColors.primaryColor),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            _getFirstThreeWords(user.source),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.bodyTextColor.withOpacity(0.8),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Separator (→ or Dotted Line)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Text(
                            '→',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.bodyTextColor.withOpacity(0.7),
                            ),
                          ),
                        ),

                        // Destination
                        Expanded(
                          child: Text(
                            _getFirstThreeWords(user.destination),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.bodyTextColor.withOpacity(0.8),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.location_on, size: 14.w, color: ThemeColors.primaryColor),
                      ],
                    ),

                    SizedBox(height: 6.h),

                    // Last Message & Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage.isNotEmpty ? ' $lastMessage' : 'No messages yet',
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
                        SizedBox(width: 8.w),
                        if (lastMessageTime.isNotEmpty)
                          Text(
                            lastMessageTime,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: ThemeColors.bodyTextColor.withOpacity(0.5),
                                  fontSize: 12.sp,
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
      ),
    );
  }

  String _getFirstThreeWords(String text) {
    List<String> words = text.split(' ');
    return words.length <= 3 ? text : '${words.take(3).join(' ')}...';
  }
}
