import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarDetails extends StatelessWidget {
  final String carModel;
  final int totalSeats;
  final int filledSeats;
  final String estimatedArrivalTime;
  final String carCompany;

  const CarDetails(
      {super.key,
      required this.carModel,
      required this.totalSeats,
      required this.filledSeats,
      required this.estimatedArrivalTime,
      required this.carCompany});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🚙 Car Model
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/car.svg',
                  width: 16.w,
                  height: 16.h,
                  color: theme.primaryColor,
                ),
                SizedBox(width: 4.w),
                Text(
                  '$carModel $carCompany',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),

            // 🪑 Seat Indicators
            Row(
              children: List.generate(totalSeats, (index) {
                bool isFilled =
                    index < filledSeats; // ✅ Check if seat is filled

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    Icons.event_seat,
                    color: isFilled
                        ? theme.primaryColor // 🟠 Filled Seat
                        : theme.primaryColorLight, // ⚪ Empty Seat
                    size: 16.sp,
                  ),
                );
              }),
            ),

            SizedBox(height: 8.h),

            // ⏳ Estimated Time
            Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 4.h,
                horizontal: 8.w,
              ),
              child: Text(
                'Estimated Time: $estimatedArrivalTime',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.scaffoldBackgroundColor,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
