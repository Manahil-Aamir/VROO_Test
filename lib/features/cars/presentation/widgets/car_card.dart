import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/core/theme/color/color_theme.dart';
import 'package:vroo_test/features/cars/presentation/widgets/delete_car.dart';

import '../../domain/entity/car.dart';

class CarCardWidget extends StatelessWidget {
  final CarEntity car;

  const CarCardWidget({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: ThemeColors.primaryColorDark.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        leading: Image.asset(
          'assets/images/car.png', // Replace icon with the image
          width: 48.r,
          height: 48.r,
        ),
        title: Text(
          '${car.company} ${car.model} - ${car.numberPlate}',
          style: TextStyle(
            color: ThemeColors.buttonTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            '${car.color}  |  ${car.mileage.toInt()} MPG',
            style: TextStyle(
              color: ThemeColors.buttonTextColor,
              fontSize: 12.sp,
            ),
          ),
        ),
        trailing: DeleteCarWidget(car: car),
      ),
    );
  }
}
