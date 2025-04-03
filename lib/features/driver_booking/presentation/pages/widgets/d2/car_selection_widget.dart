import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/color/color_theme.dart';
import '../../../../../../core/theme/font/font_theme.dart';
import '../../../../../cars/presentation/bloc/bloc/car_bloc.dart';
import '../../../../../cars/presentation/bloc/state/car_state.dart';

class CarSelectionWidget extends StatelessWidget {
  final String? selectedCarId;
  final ValueChanged<String?> onCarSelected;
  final VoidCallback onAddCarPressed;

  const CarSelectionWidget({
    Key? key,
    required this.selectedCarId,
    required this.onCarSelected,
    required this.onAddCarPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeColors.backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.w)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_car, color: ThemeColors.primaryColor, size: 24.w),
                SizedBox(width: 8.w),
                Text('Select Vehicle', style: AppFonts.bodyTextStyle.copyWith(fontSize: AppFonts.body1TextSize, color: ThemeColors.headlinesTextColor, fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(height: 16.h),
            BlocBuilder<CarBloc, CarState>(
              builder: (context, carState) {
                // First check if we have a loaded state with cars
                if (carState is CarLoaded) {
                  // Check if the selected car exists in the loaded list
                  final carExists = carState.cars.any((car) => car.numberPlate == selectedCarId);
                  
                  // Only use selectedCarId if it exists in the current list, otherwise null
                  final effectiveSelectedId = carExists ? selectedCarId : null;
                  
                  return Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: effectiveSelectedId,
                          items: carState.cars.map((car) => DropdownMenuItem(
                            value: car.numberPlate, 
                            child: Row(children: [
                              Icon(Icons.directions_car, color: ThemeColors.primaryColor), 
                              SizedBox(width: 12.w), 
                              Text('${car.company} ${car.model}')
                            ])
                          )).toList(),
                          onChanged: onCarSelected,
                          decoration: InputDecoration(
                            hintText: 'Choose your vehicle',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      _buildAddCarButton(),
                    ],
                  );
                } else if (carState is CarLoading) {
                  // Show loading state
                  return Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: null,
                          items: const [], // Empty list while loading
                          onChanged: null, // Disable while loading
                          decoration: InputDecoration(
                            hintText: 'Loading vehicles...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.w,
                                  color: ThemeColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                          icon: const SizedBox.shrink(),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      _buildAddCarButton(),
                    ],
                  );
                } else {
                  // Error or initial state
                  return Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: null,
                          items: const [], 
                          onChanged: null,
                          decoration: InputDecoration(
                            hintText: 'No vehicles available',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      _buildAddCarButton(),
                    ],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
  
  Widget _buildAddCarButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeColors.primaryColor.withOpacity(0.7),
            // ThemeColors.primaryColor,
            ThemeColors.primaryColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.w),
          onTap: onAddCarPressed,
          child: Container(
            width: 48.w,
            height: 48.w,
            padding: EdgeInsets.all(12.w),
            child: Icon(Icons.add, color: Colors.white, size: 24.w),
          ),
        ),
      ),
    );
  }
}
