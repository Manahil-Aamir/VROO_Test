import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/color/color_theme.dart';

class ToAndFroWidget extends StatelessWidget {
  final String fromDescription;
  final String toDescription;

  const ToAndFroWidget({
    super.key,
    required this.fromDescription,
    required this.toDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5,0,5,0),
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.backgroundColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.primaryColor.withOpacity(0.3),
              blurRadius: 16.r,
              spreadRadius: 4.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildLocationCard(
                context,
                icon: Icons.near_me_rounded,
                description: fromDescription,
                text: 'From'
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: _buildConnectionLine(context),
              ),
              _buildLocationCard(
                context,
                icon: Icons.flag_outlined,
                description: toDescription,
                text: 'To',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionLine(BuildContext context) {
    return Row(
              children: [
                SizedBox(width: 30.w),
                Expanded(
                  child: Container(
                    height: 2.h,
                    color: ThemeColors.primaryColor.withOpacity(0.5),
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/down-arrow.svg',
                  width: 30.r,
                  height: 40.r,
                ),
                Expanded(
                  child: Container(
                    height: 2.h,
                    color: ThemeColors.primaryColor.withOpacity(0.5),
                  ),
                ),
                SizedBox(width: 30.w),
              ],
            );
  }

  Widget _buildLocationCard(
    BuildContext context, {
    required IconData icon,
    required String description,
    required String text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.primaryColorDark.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        // border: Border.all(
        //   color: ThemeColors.primaryColor.withOpacity(0.1),
        //   width: 1.5.w,
        // ),
      ),
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [ThemeColors.primaryColor, ThemeColors.primaryColorDark,]
              ),
            ),
            child: Icon(
              icon,
              size: 20.r,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.primaryColor.withOpacity(0.6),
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16.5.sp,
                    fontWeight: FontWeight.w500,
                    color: ThemeColors.headlinesTextColor,
                    height: 1.2,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}