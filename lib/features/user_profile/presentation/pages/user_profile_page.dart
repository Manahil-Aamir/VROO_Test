import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../bloc/bloc/user_profile_bloc.dart';
import '../bloc/event/user_profile_event.dart';
import '../bloc/state/user_profile_state.dart';

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
                        _buildStatCards(user, theme),
                        SizedBox(height: 24),
                        
                        // Environmental Impact
                        _buildSectionTitle('Environmental Impact', textTheme),
                        _buildEnvironmentalImpact(user, theme),
                        SizedBox(height: 24),
                        
                        // Favorite Places
                        if (user.favouritePlaces.isNotEmpty) ...[
                          _buildSectionTitle('Favorite Places', textTheme),
                          _buildLocationsList(user.favouritePlaces, theme),
                          SizedBox(height: 24),
                        ],
                        
                        // Recent Locations
                        if (user.recentLocations.isNotEmpty) ...[
                          _buildSectionTitle('Recent Locations', textTheme),
                          _buildLocationsList(user.recentLocations, theme),
                          SizedBox(height: 32),
                        ],
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
    final theme = Theme.of(context);
    final controller = TextEditingController(text: currentName);
    
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Name updated successfully',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              );
            },
            child: Text(
              'Save',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ThemeColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPhoneDialog(BuildContext context, String currentPhone) {
    final theme = Theme.of(context);
    final controller = TextEditingController(text: currentPhone);
    
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Phone number updated successfully',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              );
            },
            child: Text(
              'Save',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ThemeColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards(dynamic user, ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Driver Rating',  
                '${user.ratingsAsDriver}',
                Icons.directions_car,
                ThemeColors.secondaryColor,
                theme,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Rider Rating',
                '${user.ratingsAsRider}',
                Icons.person,
                ThemeColors.primaryColor,
                theme,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'As Driver',
                '${user.totalRidesAsDriver}',
                Icons.drive_eta,
                ThemeColors.accentColor,
                theme,
                subtitle: 'Total Rides',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'As Rider',
                '${user.totalRidesAsRider}',
                Icons.emoji_people,
                ThemeColors.primaryColorDark,
                theme,
                subtitle: 'Total Rides',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title, 
    String value, 
    IconData icon, 
    Color color, 
    ThemeData theme, {
      String? subtitle,
    }
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.primaryColor.withOpacity(0.05), // Primary color shadow
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: ThemeColors.bodyTextColor,
            ),
          ),
          if (subtitle != null) ...[
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: ThemeColors.captionTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEnvironmentalImpact(dynamic user, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.primaryColor.withOpacity(0.05), // Primary color shadow
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.eco,
                      color: ThemeColors.secondaryColor,
                      size: 36,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${user.co2Saved} kg',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.secondaryColor,
                      ),
                    ),
                    Text(
                      'CO₂ Saved',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: ThemeColors.bodyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                width: 1,
                color: ThemeColors.dividerColor,
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.local_gas_station,
                      color: ThemeColors.primaryColor,
                      size: 36,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${user.fuelSaved} L',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.primaryColor,
                      ),
                    ),
                    Text(
                      'Fuel Saved',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: ThemeColors.bodyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ThemeColors.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.insights, 
                  color: ThemeColors.secondaryColor, 
                  size: 24
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You\'ve reduced your carbon footprint by carpooling!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ThemeColors.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: ThemeColors.dividerColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLocationsList(List<String> locations, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.primaryColor.withOpacity(0.1), // Primary color shadow
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: locations.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: ThemeColors.dividerColor,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: ThemeColors.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.location_on,
                color: ThemeColors.primaryColor,
                size: 20,
              ),
            ),
            title: Text(
              locations[index],
              style: theme.textTheme.bodyMedium,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: ThemeColors.iconColor,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            onTap: () {
              // Handle location tap
            },
          );
        },
      ),
    );
  }

}