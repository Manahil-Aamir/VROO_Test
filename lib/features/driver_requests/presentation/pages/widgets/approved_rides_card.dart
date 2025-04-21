import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/router/navigation.dart';
import '../../../../../core/theme/color/color_theme.dart';
import '../../../../../core/services/phone_service.dart'; 
import '../../../../../shared/widgets/custom_dialog.dart';
import '../../../../chat/domain/entity/chat_user.dart';
import '../../../domain/entity/approved_rides.dart'; 

class ApprovedRideCard extends StatelessWidget {
  final ApprovedRidesEntity ride;

  const ApprovedRideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      color: ThemeColors.primaryColorDark,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with user info and date/time
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(Icons.person, color: Colors.white, size: 22.r),
                ),
                SizedBox(width: 12.w),
                
                // Name and rating - with more width
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name with proper width
                      Text(
                        ride.riderName,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 4.h),
                      // Rating
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: ThemeColors.primaryColor, size: 14.r),
                          SizedBox(width: 4.w),
                          Text(
                            '${ride.ratings.asRider}',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                // Date and time info aligned right
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy').format(ride.date),
                      style: textTheme.bodySmall?.copyWith(
                        color: ThemeColors.buttonTextColor,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time_rounded, color: ThemeColors.primaryColor, size: 14.r),
                        SizedBox(width: 4.w),
                        Text(
                          DateFormat('h:mm a').format(ride.pickupTimeRange.min),
                          style: textTheme.bodySmall?.copyWith(
                            color: ThemeColors.buttonTextColor,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Route information row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Location icons
                Column(
                  children: [
                    Icon(
                      Icons.circle_outlined,
                      color: ThemeColors.primaryColor,
                      size: 16.r,
                    ),
                    Container(
                      height: 12.h,
                      width: 1.w,
                      color: ThemeColors.primaryColor.withOpacity(0.6),
                    ),
                    Icon(
                      Icons.location_on,
                      color: ThemeColors.primaryColor,
                      size: 16.r,
                    ),
                  ],
                ),
                SizedBox(width: 12.w),
                
                // Locations
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source location in single line
                      Text(
                        ride.source,
                        style: textTheme.bodyMedium?.copyWith(
                          color: ThemeColors.buttonTextColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      
                      // Destination in single line
                      Text(
                        ride.destination,
                        style: textTheme.bodyMedium?.copyWith(
                          color: ThemeColors.buttonTextColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 18.w),
                // Price
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: ThemeColors.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Rs. ${ride.fare}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: ThemeColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ],
            ),
            
            // Action buttons row
            SizedBox(height: 16.h),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }
  
  // Action buttons with icons
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 34.h,
            child: ElevatedButton.icon(
              onPressed: () {
                // Implement message functionality
                _navigateToChat(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 0),
              ),
              icon: Icon(
                Icons.chat_rounded,
                size: 18.r,
                color: Colors.white,
              ),
              label: Text(
                'Message',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: SizedBox(
            height: 34.h,
            child: ElevatedButton.icon(
              onPressed: () => _showCallConfirmation(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 0),
              ),
              icon: Icon(
                Icons.call_rounded,
                size: 18.r,
                color: Colors.white,
              ),
              label: Text(
                'Call',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToChat(BuildContext context) {
    // Create a ChatUser from the ApprovedRidesEntity
    final chatUser = ChatUser(
      id: ride.riderId,
      name: ride.riderName,
      fcmToken: ride.fcmToken, 
      source: ride.source,
      destination: ride.destination,
      date: ride.date,
    );
    context.read<Navigation>().navigateTo('/chat_detail', arguments: chatUser);

    // Navigate to the chat detail screen
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => ChatDetailScreen(user: chatUser),
    //   ),
    // );
  }

  void _showCallConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Call Rider",
        message: "Do you want to call ${ride.riderName}?",
        confirmText: "Call",
        cancelText: "Cancel",
        confirmColor: ThemeColors.primaryColor,
        cancelColor: ThemeColors.accentColor,
        onConfirm: () async {
          Navigator.of(context).pop();
          try {
            // Assuming the rider has a phoneNumber property in ApprovedRidesEntity
            // If not, you'll need to add it to the entity
            await PhoneService.makePhoneCall(ride.phoneNumber);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to make call: $e')),
            );
          }
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}
