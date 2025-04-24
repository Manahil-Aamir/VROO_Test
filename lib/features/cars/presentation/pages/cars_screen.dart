import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../domain/entity/car.dart';
import '../bloc/bloc/car_bloc.dart';
import '../bloc/event/car_event.dart';
import '../bloc/state/car_state.dart';
import '../widgets/add_car_modal.dart';
import '../widgets/car_card.dart';

class CarScreen extends StatefulWidget {
  const CarScreen({super.key});

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
                  Image.asset(
                    'assets/images/error.png',
                    width: 300.w,
                    height: 300.h,
                    fit: BoxFit.contain,
                  ),
                  // SizedBox(height: 16.h),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 32.w),
                  //   child: Text(
                  //     'Failed to load cars. Please try again later.',
                  //     style: TextStyle(
                  //       color: ThemeColors.buttonTextColor,
                  //       fontSize: 16.sp,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                ],
              ),
            );
          } else if (state is CarEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Spacer(),
                  Center(
                    child: Text(
                      'No cars found. Please add a car.',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: ThemeColors.buttonDisabledTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  GradientButton(
                    text: 'Add Car',
                    onTap: () {
                      _showAddCarModal(context);
                    },
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            );
          } else if (state is CarLoaded || state is CarAdded) {
            final List<CarEntity> cars =
                state is CarLoaded ? state.cars : (state as CarAdded).cars;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      return CarCardWidget(car: car);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: GradientButton(
                    onTap: () => _showAddCarModal(context),
                    text: 'Add car',
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
          // return Center(
          //   child: Image.asset(
          //     'assets/images/error.png',
          //     width: 200.w,
          //     height: 200.h,
          //     fit: BoxFit.contain,
          //   ),
          // );
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/error.png',
                  width: 400.w,
                  height: 400.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Unable to load car information',
                  style: TextStyle(color: ThemeColors.buttonTextColor),
                ),
              ],
            ),
          );
        },
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
}
