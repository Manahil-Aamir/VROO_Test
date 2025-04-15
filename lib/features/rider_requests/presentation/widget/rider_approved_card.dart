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
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ThemeColors.primaryColorDark,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateTimeRow(textTheme),
              Divider(color: ThemeColors.buttonTextColor.withOpacity(0.2), height: 18.h),
              _buildDriverAndCarInfo(context, textTheme),
              SizedBox(height: 12.h),
              _buildRouteInfo(textTheme),
              SizedBox(height: 12.h),
              _buildPassengerInfo(textTheme),
              SizedBox(height: 14.h),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeRow(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 14.r, color: ThemeColors.primaryColor),
            SizedBox(width: 6.w),
            Text(
              DateFormat('dd MMM yyyy').format(request.date),
              style: textTheme.labelMedium?.copyWith(
                fontSize: 13.sp,
                color: ThemeColors.buttonTextColor,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.access_time_rounded, size: 16.r, color: ThemeColors.primaryColor),
            SizedBox(width: 4.w),
            Text(
              DateFormat('h:mm a').format(request.departureTime),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
                color: ThemeColors.buttonTextColor,
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
        color: ThemeColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: ThemeColors.primaryColor,
            child: Text(
              request.driver.name[0].toUpperCase(),
              style: textTheme.titleMedium?.copyWith(
                color: ThemeColors.buttonTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.driver.name,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: ThemeColors.buttonTextColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 14.r),
                    SizedBox(width: 3.w),
                    Text(
                      '${request.driver.rating.asDriver} · ${request.driver.totalRides.asDriver} rides',
                      style: textTheme.bodySmall?.copyWith(
                        color: ThemeColors.buttonTextColor.withOpacity(0.7),
                        fontSize: 11.sp,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(Icons.directions_car_filled_rounded, color: ThemeColors.primaryColor, size: 18.r),
                  SizedBox(width: 4.w),
                  Text(
                    '${request.car.company} ${request.car.model}',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      color: ThemeColors.buttonTextColor,
                    ),
                  ),
                ],
              ),
              Text(
                '${request.car.color} · ${request.car.numberPlate}',
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 11.sp,
                  color: ThemeColors.buttonTextColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerInfo(TextTheme textTheme) {
    if (request.passengers.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Passengers:',
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: ThemeColors.buttonTextColor,
          ),
        ),
        SizedBox(height: 6.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: request.passengers.map((passenger) {
              return Container(
                margin: EdgeInsets.only(right: 6.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: ThemeColors.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.r),
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
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 38.h,
            child: DialogButton(
              onTap: () {},
              text: 'Message',
              color: ThemeColors.primaryColor,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: SizedBox(
            height: 38.h,
            child: DialogButton(
              onTap: () => _showCancelConfirmation(context),
              text: 'Cancel',
              color: ThemeColors.accentColor,
              // radius: 12.r,
            ),
          ),
        ),
      ],
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Cancel Ride",
        message: "Are you sure you want to cancel this approved ride?",
        confirmText: "Yes",
        cancelText: "No",
        confirmColor: ThemeColors.accentColor,
        cancelColor: ThemeColors.primaryColor,
        onConfirm: () => Navigator.of(context).pop(),
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}
