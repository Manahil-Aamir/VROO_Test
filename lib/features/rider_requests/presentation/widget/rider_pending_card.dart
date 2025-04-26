// lib/presentation/widgets/pending_request_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/custom_dialog.dart';
import '../../../../shared/widgets/dialog_button.dart';
import '../../domain/entity/rider_pending_request_entity.dart';

class PendingRequestCard extends StatelessWidget {
  final RiderPendingRequest request;

  const PendingRequestCard({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        // call join card with argument 
        context.read<Navigation>().navigateTo(
          '/rider_request_joins',
          arguments: request.id,
        );
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        color: ThemeColors.primaryColorDark,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateTimeRow(context, textTheme),
              Divider(
                color: ThemeColors.buttonTextColor.withOpacity(0.15),
                height: 16.h,
                thickness: 0.5,
              ),
              _buildRouteInfo(textTheme),
              if (_hasPreferences) SizedBox(height: 12.h),
              if (_hasPreferences) Row(
                children: [
                  Expanded(child: _buildPreferences(textTheme)),
                  SizedBox(width: 6.h),
                  _buildCancelButton(context),
                ],
              ),
              if (!_hasPreferences) Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildCancelButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _hasPreferences {
    return request.preferences.femaleOnly || request.preferences.maleOnly || request.preferences.canWalk;
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
        
        // Time info
        Row(
          children: [
            Icon(
              Icons.access_time_rounded, 
              color: ThemeColors.primaryColor, 
              size: 16.r
            ),
            SizedBox(width: 4.w),
            Text(
              "${DateFormat('h:mm a').format(request.pickupTimeRange.min)} - "
              "${DateFormat('h:mm a').format(request.pickupTimeRange.max)}",
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
              // Source location in single line
              Text(
                request.source.address,
                style: textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.buttonTextColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6.h),
              
              // Destination in single line
              Text(
                request.destination.address,
                style: textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.buttonTextColor,
                  fontSize: 15.sp,
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

  Widget _buildPreferences(TextTheme textTheme) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        if (request.preferences.femaleOnly)
          _buildPreferenceChip('Female Only', Icons.female, textTheme),
        if (request.preferences.maleOnly)
          _buildPreferenceChip('Male Only', Icons.male, textTheme),
        if (request.preferences.canWalk)
          _buildPreferenceChip('Can Walk', Icons.directions_walk, textTheme),
      ],
    );
  }

  Widget _buildPreferenceChip(String text, IconData icon, TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ThemeColors.primaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: ThemeColors.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.r,
            color: ThemeColors.buttonTextColor,
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              color: ThemeColors.buttonTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      height: 33.h,
      child: DialogButton(
        onTap: () {
          _showCancelConfirmation(context);
        },
        text: 'Cancel',
        color: ThemeColors.accentColor,
      ),
    );
  }
  
  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: "Cancel Request",
        message: "Are you sure you want to cancel this ride request?",
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
