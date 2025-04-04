import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/color/color_theme.dart';
import '../../domain/entity/car.dart';
import '../bloc/bloc/car_bloc.dart';
import '../bloc/event/car_event.dart';

class DeleteCarWidget extends StatelessWidget {
  final CarEntity car;

  const DeleteCarWidget({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.delete_forever,
        color: ThemeColors.primaryColor,
      ),
      onPressed: () => _showDeleteConfirmation(context),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF3C3C3C),
        title: Text(
          'Are you sure you want to delete this?',
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
                _deleteCar(context);
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

  void _deleteCar(BuildContext context) {
    final carBloc = BlocProvider.of<CarBloc>(context);
    carBloc.add(DeleteCar(car.carId));
    
    // Show a progress indicator while the car is being deleted
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted ${car.company} ${car.model}...'),
        backgroundColor: ThemeColors.secondaryColor,
      ),
    );
  }
}
