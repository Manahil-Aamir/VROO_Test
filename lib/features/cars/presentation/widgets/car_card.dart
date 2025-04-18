import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/core/theme/color/color_theme.dart';
import 'package:vroo_test/features/cars/presentation/widgets/delete_car.dart';
import 'package:vroo_test/features/cars/presentation/widgets/update_mileage_modal.dart';

import '../../domain/entity/car.dart';
import '../bloc/bloc/car_bloc.dart';

class CarCardWidget extends StatelessWidget {
  final CarEntity car;

  const CarCardWidget({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: ThemeColors.primaryColorDark.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            leading: Image.asset(
              'assets/images/car.png',
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
          Divider(
            color: ThemeColors.backgroundColor.withOpacity(0.2),
            height: 1,
            indent: 16.w,
            endIndent: 16.w,
          ),
          InkWell(
            onTap: () => _showUpdateMileageModal(context, car),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.r),
              bottomRight: Radius.circular(8.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.speed_rounded,
                    color: ThemeColors.buttonTextColor,
                    size: 18.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Update Mileage',
                    style: TextStyle(
                      color: ThemeColors.buttonTextColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateMileageModal(BuildContext context, CarEntity car) {
    final carBloc = context.read<CarBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeColors.primaryColorDark.withRed(30).withBlue(30).withGreen(30),
      builder: (context) => UpdateMileageModal(
        car: car,
        carBloc: carBloc,
      ),
    );
  }
}
