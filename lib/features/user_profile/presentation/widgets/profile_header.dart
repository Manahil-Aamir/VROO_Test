import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../bloc/bloc/user_profile_bloc.dart';
import '../bloc/event/user_profile_event.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic user;
  
  const ProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String initials = _getInitials(user.name);
    
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ThemeColors.primaryColor, 
            ThemeColors.primaryColor.withOpacity(0.5)
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.r),
          bottomRight: Radius.circular(25.r),
        ),
      ),
      child: Column(
        children: [
          // Profile image with edit button
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ThemeColors.backgroundColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.headlinesTextColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: ThemeColors.primaryColor.withOpacity(0.2),
                  child: Text(
                    initials,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: ThemeColors.primaryColor,
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: ThemeColors.primaryColor,
                child: Icon(
                  Icons.camera_alt, 
                  size: 18, 
                  color: ThemeColors.buttonTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // User name (with edit option)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.headlinesTextColor,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _showEditNameDialog(context, user.name),
                child: Icon(
                  Icons.edit,
                  size: 18,
                  color: ThemeColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // User email (non-editable)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email, size: 16, color: ThemeColors.appBarIconsColor),
              const SizedBox(width: 6),
              Text(
                user.email,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ThemeColors.appBarIconsColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // User phone (with edit option)
          InkWell(
            onTap: () => _showEditPhoneDialog(context, user.phoneNumber),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ThemeColors.backgroundColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ThemeColors.backgroundColor.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone, size: 16, color: ThemeColors.headlinesTextColor),
                  const SizedBox(width: 6),
                  Text(
                    user.phoneNumber,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ThemeColors.headlinesTextColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.edit, size: 14, color: ThemeColors.primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length > 1) {
      return '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
    } else if (nameParts.length == 1) {
      return nameParts.first[0].toUpperCase();
    }
    return '';
  }

  // Update the dialog methods in ProfileHeader widget

  void _showEditNameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    final userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ThemeColors.backgroundColor,
        contentPadding: EdgeInsets.fromLTRB(24.w, 15.h, 24.w, 24.h),
        titlePadding: EdgeInsets.all(16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit, color: ThemeColors.primaryColor),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Edit Name',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: ThemeColors.headlinesTextColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: ThemeColors.primaryColor),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ],
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(color: ThemeColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(color: ThemeColors.primaryColor),
            ),
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: ThemeColors.headlinesTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ThemeColors.primaryColor,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && newName != currentName) {
                userProfileBloc.add(UpdateUserProfileEvent(name: newName));
              }
              Navigator.pop(dialogContext);
            },
            child: Text(
              'Save',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ThemeColors.buttonTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPhoneDialog(BuildContext context, String currentPhone) {
    final controller = TextEditingController(text: currentPhone);
    final userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ThemeColors.backgroundColor,
        contentPadding: EdgeInsets.fromLTRB(24.w, 15.h, 24.w, 24.h),
        titlePadding: EdgeInsets.all(16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.phone, color: ThemeColors.primaryColor),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Edit Phone Number',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: ThemeColors.headlinesTextColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: ThemeColors.primaryColor),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ],
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(color: ThemeColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(color: ThemeColors.primaryColor),
            ),
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: ThemeColors.headlinesTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ThemeColors.primaryColor,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            onPressed: () {
              final newPhone = controller.text.trim();
              if (newPhone.isNotEmpty && newPhone != currentPhone) {
                userProfileBloc.add(UpdateUserProfileEvent(phoneNumber: newPhone));
              }
              Navigator.pop(dialogContext);
            },
            child: Text(
              'Save',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ThemeColors.buttonTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
