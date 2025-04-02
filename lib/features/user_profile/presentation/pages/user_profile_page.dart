import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../domain/usecase/update_user_profile.dart';
import '../bloc/bloc/user_profile_bloc.dart';
import '../bloc/event/user_profile_event.dart';
import '../bloc/state/user_profile_state.dart';
import '../widgets/environmental_impact.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_cards.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserProfileBloc>(context).add(LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    
    return Scaffold(
      backgroundColor: ThemeColors.scaffoldBackgroundColor,
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: ThemeColors.progressIndicatorColor,
              ),
            );
          } else if (state is UserProfileLoaded) {
            final user = state.userProfile;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with profile info
                  _buildProfileHeader(user, theme),
                  
                  // Stats sections
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24),
                        StatCards(user: state.userProfile),
                        SizedBox(height: 24),
                        SectionTitle(title: 'Environmental Impact'),
                        EnvironmentalImpact(user: state.userProfile),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),             
                ],
              ),
            );
          } else if (state is UserProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: ThemeColors.accentColor),
                  SizedBox(height: 16),
                  Text(
                    state.message,
                    style: textTheme.bodyMedium?.copyWith(color: ThemeColors.accentColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<UserProfileBloc>(context).add(LoadUserProfile());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.buttonColor,
                      foregroundColor: ThemeColors.buttonTextColor,
                    ),
                    child: Text('Try Again', style: textTheme.labelLarge),
                  ),
                ],
              ),
            );
          }
          return SizedBox();
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
    );
  }

  Widget _buildProfileHeader(dynamic user, ThemeData theme) {
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
          // Profile image with edit button
          Stack(
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
          ),
          SizedBox(height: 16),
          
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
              SizedBox(width: 8),
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
          SizedBox(height: 8),
          
          // User email (non-editable)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email, size: 16, color: ThemeColors.bodyTextColor),
              SizedBox(width: 6),
              Text(
                user.email,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ThemeColors.bodyTextColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          
          // User phone (with edit option)
          InkWell(
            onTap: () => _showEditPhoneDialog(context, user.phoneNumber),
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
                    user.phoneNumber,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ThemeColors.headlinesTextColor,
                    ),
                  ),
                  SizedBox(width: 6),
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

void _showEditNameDialog(BuildContext context, String currentName) {
  final controller = TextEditingController(text: currentName);
  // Capture the bloc outside the dialog
  final userProfileBloc = BlocProvider.of<UserProfileBloc>(context);

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Edit Name'),
      content: TextField(controller: controller, decoration: InputDecoration(border: OutlineInputBorder())),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Cancel')),
        TextButton(
          onPressed: () {
            final newName = controller.text.trim();
            if (newName.isNotEmpty && newName != currentName) {
              // Use the captured bloc instead of trying to get it from dialogContext
              userProfileBloc.add(UpdateUserProfileEvent(name: newName));
            }
            Navigator.pop(dialogContext);
          },
          child: Text('Save'),
        ),
      ],
    ),
  );
}

void _showEditPhoneDialog(BuildContext context, String currentPhone) {
  final controller = TextEditingController(text: currentPhone);
  // Capture the bloc outside the dialog
  final userProfileBloc = BlocProvider.of<UserProfileBloc>(context);

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Edit Phone Number'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Cancel')),
        TextButton(
          onPressed: () {
            final newPhone = controller.text.trim();
            if (newPhone.isNotEmpty && newPhone != currentPhone) {
              // Use the captured bloc instead of trying to get it from dialogContext
              userProfileBloc.add(UpdateUserProfileEvent(phoneNumber: newPhone));
            }
            Navigator.pop(dialogContext);
          },
          child: Text('Save'),
        ),
      ],
    ),
  );
}
}