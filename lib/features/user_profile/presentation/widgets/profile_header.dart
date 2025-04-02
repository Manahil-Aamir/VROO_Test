import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../bloc/bloc/user_profile_bloc.dart';
import '../bloc/event/user_profile_event.dart';
import '../bloc/state/user_profile_state.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic user;
  
  const ProfileHeader({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String initials = _getInitials(user.name);
    
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ThemeColors.primaryColor.withOpacity(0.8), 
            ThemeColors.primaryColor.withOpacity(0.1)
          ],
        ),
      ),
      child: Column(
        children: [
          _buildProfileImage(initials, theme),
          SizedBox(height: 16),
          _buildUserName(user.name, theme, context),
          SizedBox(height: 8),
          _buildUserEmail(user.email, theme),
          SizedBox(height: 8),
          _buildUserPhone(user.phoneNumber, context),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String initials, ThemeData theme) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: ThemeColors.backgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ThemeColors.headlinesTextColor.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
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
            color: ThemeColors.buttonTextColor
          ),
        ),
      ],
    );
  }

  Widget _buildUserName(String name, ThemeData theme, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: ThemeColors.headlinesTextColor,
          ),
        ),
        SizedBox(width: 8),
        InkWell(
          onTap: () => _showEditNameDialog(context, name),
          child: Icon(
            Icons.edit,
            size: 18,
            color: ThemeColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildUserEmail(String email, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.email, size: 16, color: ThemeColors.headlinesTextColor.withOpacity(0.5)),
        SizedBox(width: 6),
        Text(
          email,
          style: theme.textTheme.bodySmall?.copyWith(
            color: ThemeColors.headlinesTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildUserPhone(String phone, BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _showEditPhoneDialog(context, phone),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: ThemeColors.backgroundColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ThemeColors.backgroundColor.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone, size: 16, color: ThemeColors.headlinesTextColor),
            SizedBox(width: 6),
            Text(
              phone,
              style: theme.textTheme.bodySmall?.copyWith(
                color: ThemeColors.headlinesTextColor,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.edit, size: 14, color: ThemeColors.primaryColor),
          ],
        ),
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

  void _showEditNameDialog(BuildContext context, String currentName) {
    final theme = Theme.of(context);
    final controller = TextEditingController(text: currentName);
    final userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Name',
          style: theme.textTheme.titleLarge,
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: theme.textTheme.bodySmall?.copyWith(
              color: ThemeColors.hintTextColor,
            ),
            border: OutlineInputBorder(),
          ),
          style: theme.textTheme.bodyMedium,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ThemeColors.bodyTextColor,
              ),
            ),
          ),
          BlocConsumer<UserProfileBloc, UserProfileState>(
            listener: (context, state) {
              if (state is UserProfileLoaded) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Name updated successfully')),
                );
              } else if (state is UserProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update name')),
                );
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: state is UserProfileLoading
                    ? null
                    : () {
                        userProfileBloc.add(UpdateUserProfileEvent(name: controller.text));
                      },
                child: state is UserProfileLoading
                    ? CircularProgressIndicator()
                    : Text(
                        'Save',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ThemeColors.primaryColor,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEditPhoneDialog(BuildContext context, String currentPhone) {
    final theme = Theme.of(context);
    final controller = TextEditingController(text: currentPhone);
    final userProfileBloc = BlocProvider.of<UserProfileBloc>(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Phone Number',
          style: theme.textTheme.titleLarge,
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter your phone number',
            hintStyle: theme.textTheme.bodySmall?.copyWith(
              color: ThemeColors.hintTextColor,
            ),
            border: OutlineInputBorder(),
          ),
          style: theme.textTheme.bodyMedium,
          keyboardType: TextInputType.phone,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ThemeColors.bodyTextColor,
              ),
            ),
          ),
          BlocConsumer<UserProfileBloc, UserProfileState>(
            listener: (context, state) {
              if (state is UserProfileLoaded) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Phone number updated successfully')),
                );
              } else if (state is UserProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update phone number')),
                );
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: state is UserProfileLoading
                    ? null
                    : () {
                        userProfileBloc.add(UpdateUserProfileEvent(phoneNumber: controller.text));
                      },
                child: state is UserProfileLoading
                    ? CircularProgressIndicator()
                    : Text(
                        'Save',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ThemeColors.primaryColor,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

}
