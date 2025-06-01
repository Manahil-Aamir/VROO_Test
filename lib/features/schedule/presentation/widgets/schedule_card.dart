import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../core/theme/font/font_theme.dart';
import '../../domain/entity/schedule_entity.dart';
import '../bloc/bloc/schedule_bloc.dart';
import '../bloc/event/schedule_event.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleEntity schedule;
  final String role;

  const ScheduleCard({
    Key? key,
    required this.schedule,
    required this.role,
  }) : super(key: key);

String _getShortDayName(String fullDayName) {
    switch (fullDayName) {
      case 'Monday':
        return 'M';
      case 'Tuesday':
        return 'T';
      case 'Wednesday':
        return 'W';
      case 'Thursday':
        return 'Th';
      case 'Friday':
        return 'F';
      case 'Saturday':
        return 'Sa';
      case 'Sunday':
        return 'Su';
      default:
        return fullDayName;
    }
  }

  String _formatDays(List<String> days) {
    if (schedule.frequency.toLowerCase() == 'daily') {
      return 'Daily';
    } else if (schedule.frequency.toLowerCase() == 'weekly') {
      return 'Weekly';
    } else {
      return days.map((day) => _getShortDayName(day)).join('/');
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF3C3C3C),
        title: Text(
          'Are you sure you want to delete this schedule?',
          style: TextStyle(
            color: ThemeColors.buttonTextColor,
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: ThemeColors.buttonTextColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<ScheduleBloc>().add(
                  DeleteScheduleEvent(id: schedule.id, role: role),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: ThemeColors.primaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: ThemeColors.buttonTextColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ThemeColors.primaryColorDark,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Row
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: ThemeColors.primaryColor,
                      size: 20.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      DateFormat('h:mm a').format(schedule.time),
                      style: AppFonts.headlineTextStyle.copyWith(
                        fontSize: AppFonts.headline5TextSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Source and Destination Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From',
                            style: AppFonts.bodyTextStyle.copyWith(
                              fontSize: AppFonts.captionTextSize,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            schedule.source.address,
                            style: AppFonts.headlineTextStyle.copyWith(
                              fontSize: AppFonts.body2TextSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white.withOpacity(0.5),
                      size: 20.w,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To',
                            style: AppFonts.bodyTextStyle.copyWith(
                              fontSize: AppFonts.captionTextSize,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            schedule.destination.address,
                            style: AppFonts.headlineTextStyle.copyWith(
                              fontSize: AppFonts.body2TextSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Bottom Row (End Date and Days)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // End Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white.withOpacity(0.5),
                          size: 16.w,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Until ${DateFormat('MMM dd, yyyy').format(schedule.endingDate)}',
                          style: AppFonts.bodyTextStyle.copyWith(
                            fontSize: AppFonts.captionTextSize,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),

                    // Days Pill
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: ThemeColors.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        _formatDays(schedule.days),
                        style: AppFonts.bodyTextStyle.copyWith(
                          fontSize: AppFonts.captionTextSize,
                          fontWeight: FontWeight.w500,
                          color: ThemeColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete icon button
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.white.withOpacity(0.7)),
              onPressed: () => _showDeleteConfirmation(context),
              splashRadius: 20,
              tooltip: 'Delete schedule',
            ),
          ),
        ],
      ),
    );
  }
}
