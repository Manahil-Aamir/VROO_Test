import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/core/theme/color/color_theme.dart';
import 'package:vroo_test/features/cars/domain/entity/car.dart';
import 'package:vroo_test/features/cars/presentation/widgets/add_car_modal.dart';

import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../bloc/bloc/car_bloc.dart';
import '../bloc/event/car_event.dart';
import '../bloc/state/car_state.dart';

class CarScreen extends StatefulWidget {
  const CarScreen({Key? key}) : super(key: key);

  @override
  State<CarScreen> createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CarBloc>().add(FetchCars());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor,
      appBar: appBar(heading: 'Your Cars'),
      body: BlocBuilder<CarBloc, CarState>(
        builder: (context, state) {
          if (state is CarLoading) {
            return const Center(
              child: CircularProgressIndicator(color: ThemeColors.primaryColor),
            );
          } else if (state is CarError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: ThemeColors.buttonTextColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => context.read<CarBloc>().add(FetchCars()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is CarLoaded || state is CarAdded) {
            final List<CarEntity> cars = state is CarLoaded
                ? state.cars
                : (state as CarAdded).cars;

            return Column(
              children: [
                Expanded(
                  child: cars.isEmpty
                      ? Center(
                          child: Text(
                            'No cars added yet',
                            style: TextStyle(color: ThemeColors.buttonTextColor),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          itemCount: cars.length,
                          itemBuilder: (context, index) {
                            final car = cars[index];
                            return _buildCarCard(context, car);
                          },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: GradientButton(
                    onTap: () => _showAddCarModal(context),
                    text: 'Add a car',
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      color: ThemeColors.primaryColorDark,
                      size: 24.r,
                    ),
                    gapBetweenIconAndText: 8.w,
                  ),
                ),
              ],
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No cars available',
                  style: TextStyle(color: ThemeColors.buttonTextColor),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => context.read<CarBloc>().add(FetchCars()),
                  child: const Text('Load Cars'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, CarEntity car) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: ThemeColors.primaryColorDark.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        leading: Icon(
          Icons.car,
          size: 48.r,
          color: ThemeColors.buttonTextColor,
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
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_forever,
            color: ThemeColors.primaryColor,
          ),
          onPressed: () => _showDeleteConfirmation(context, car),
        ),
      ),
    );
  }

  void _showAddCarModal(BuildContext context) {
    final carBloc = context.read<CarBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2C2C2C),
      builder: (context) => AddCarModal(
        carBloc: carBloc,
        onCarAdded: (newCar) {
          carBloc.add(AddCar(newCar));
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, CarEntity car) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              onPressed: () => Navigator.of(context).pop(),
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
                Navigator.of(context).pop();
                _deleteCar(context, car);
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

  void _deleteCar(BuildContext context, CarEntity car) {
    // You'll need to add the delete functionality to your CarBloc
    // For now, we'll just refresh the car list
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Delete functionality to be implemented for ${car.company} ${car.model}'),
        backgroundColor: ThemeColors.primaryColor,
      ),
    );

    // Refresh the car list
    context.read<CarBloc>().add(FetchCars());
  }
}
