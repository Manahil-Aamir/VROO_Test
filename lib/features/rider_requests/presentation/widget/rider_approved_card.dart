import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/custom_dialog.dart';
import '../../../../shared/widgets/dialog_button.dart';
import '../../domain/entity/rider_approved_request_entity.dart';

class ApprovedRequestCard extends StatelessWidget {
  final RiderApprovedRequest request;

  const ApprovedRequestCard({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        color: ThemeColors.primaryColorDark,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateTimeRow(context, textTheme),
              Divider(
                color: ThemeColors.buttonTextColor.withOpacity(0.15),
                height: 16.h,
                thickness: 0.5,
              ),
              _buildDriverAndCarInfo(context, textTheme),
              SizedBox(height: 10.h),
              _buildRouteInfo(textTheme),
              SizedBox(height: 10.h),
              _buildPassengerInfo(textTheme),
              SizedBox(height: 10.h),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeRow(BuildContext context, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Date info
        Row(
          children: [
            SizedBox(width: 2.w),
            Icon(Icons.calendar_today, size: 14.r, color: ThemeColors.primaryColor),
            SizedBox(width: 6.w),
            Text(
              DateFormat('dd MMM yyyy').format(request.date),
              style: textTheme.bodySmall?.copyWith(
                color: ThemeColors.buttonTextColor,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        
        // Departure time info
        Row(
          children: [
            Icon(
              Icons.access_time_rounded, 
              color: ThemeColors.primaryColor, 
              size: 16.r
            ),
            SizedBox(width: 4.w),
            Text(
              DateFormat('h:mm a').format(request.departureTime),
              style: textTheme.bodyMedium?.copyWith(
                color: ThemeColors.buttonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteInfo(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Icon(
              Icons.circle_outlined,
              color: ThemeColors.primaryColor,
              size: 16.r,
            ),
            Container(
              height: 8.h,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.source.address,
                style: textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.buttonTextColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6.h),
              
              Text(
                request.destination.address,
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
      ],
    );
  }

  Widget _buildDriverAndCarInfo(BuildContext context, TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: ThemeColors.primaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: ThemeColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Driver info
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: ThemeColors.primaryColor,
                  radius: 16.r,
                  child: Text(
                    request.driver.name.substring(0, 1).toUpperCase(),
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.buttonTextColor,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.driver.name,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: ThemeColors.buttonTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 12.r),
                          SizedBox(width: 2.w),
                          Text(
                            '${request.driver.rating.asDriver} · ${request.driver.totalRides.asDriver} rides',
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 11.sp,
                              color: ThemeColors.buttonTextColor.withOpacity(0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(6.r),
                  child: Icon(
                    Icons.phone,
                    color: Colors.green,
                    size: 14.r,
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          SizedBox(width: 8.w),
          Container(
            height: 36.h,
            width: 1,
            color: ThemeColors.primaryColor.withOpacity(0.2),
          ),
          SizedBox(width: 8.w),
          
          // Car info
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.directions_car, 
                  size: 20.r, 
                  color: ThemeColors.primaryColor
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${request.car.company} ${request.car.model}',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: ThemeColors.buttonTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${request.car.color} · ${request.car.numberPlate}',
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 11.sp,
                          color: ThemeColors.buttonTextColor.withOpacity(0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerInfo(TextTheme textTheme) {
    if (request.passengers.isEmpty) {
      return SizedBox.shrink();
    }
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(
            'Passengers: ',
            style: textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              color: ThemeColors.buttonTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          ...request.passengers.map((passenger) {
            return Container(
              margin: EdgeInsets.only(right: 6.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: ThemeColors.primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: ThemeColors.primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                passenger.name,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  color: ThemeColors.buttonTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 36.h,
            child: DialogButton(
              onTap: () {
                // For messaging functionality
              },
              text: 'Message',
              color: ThemeColors.primaryColor,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: SizedBox(
            height: 36.h,
            child: DialogButton(
              onTap: () {
                _showCancelConfirmation(context);
              },
              text: 'Cancel',
              color: ThemeColors.accentColor,
            ),
          ),
        ),
      ],
    );
  }
  
  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: "Cancel Ride",
        message: "Are you sure you want to cancel this approved ride?",
        confirmText: "Yes",
        cancelText: "No",
        confirmColor: ThemeColors.accentColor,
        cancelColor: ThemeColors.primaryColor,
        onConfirm: () {
          // Functionality to be added later
          Navigator.of(context).pop();
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
