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
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 🚙 Car Model and Company
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.all(4.w),
              child: SvgPicture.asset(
                'assets/images/car.svg',
                width: 16.w,
                height: 16.h,
                color: theme.primaryColor,
              ),
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
        Spacer(), // 🛋️ Spacer to push the next widget to the right

        // 🪑 Seat Indicators
        Row(
          children: List.generate(totalSeats, (index) {
            bool isFilled = index < filledSeats; // ✅ Check if seat is filled

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
      ],
    );
  }
}
