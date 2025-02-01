import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/custom_app_bar.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../../../core/theme/font/font_theme.dart';
import '../../domain/entity/car.dart';
import '../../domain/entity/driver_schedule2_entity.dart';
import '../bloc/bloc/car_bloc.dart';
import '../bloc/bloc/driver_schedule2_bloc.dart';
import '../bloc/event/car_event.dart';
import '../bloc/event/driver_schedule2_event.dart';
import '../bloc/state/car_state.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../bloc/state/driver_schedule2_state.dart';

class D2Page extends StatefulWidget {
  final String fromPlaceId;
  final String toPlaceId;
  final String fromDescription;
  final String toDescription;
  final List<dynamic> selectedRouteCoords;
  final String routeDistance;
  final String routeDuration;
  final String date;
  final String time;
  final String maxArrivalTime;
  final String recurrence;

  const D2Page({
    Key? key,
    required this.fromDescription,
    required this.toDescription,
    required this.fromPlaceId,
    required this.toPlaceId,
    required this.routeDistance,
    required this.routeDuration,
    required this.date,
    required this.time,
    required this.recurrence,
    required this.maxArrivalTime,
    required this.selectedRouteCoords,
  }) : super(key: key);

  @override
  _D2PageState createState() => _D2PageState();
}

class _D2PageState extends State<D2Page> {
  String? _selectedCarId;
  int _availableSeats = 2;
  bool _sameGenderOnly = false;
  String _selectedPaymentMethod = 'cash'; 


  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    context.read<CarBloc>().add(FetchCars());
    context.read<CarPreferencesBloc>().add(LoadCarPreferencesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CarPreferencesBloc, CarPreferencesState>(
          listener: (context, state) {
            if (state is CarPreferencesLoaded) {
              _updateLocalState(state.preferences);
            }
          },
        ),
        BlocListener<CarBloc, CarState>(
          listener: (context, state) {
            if (state is CarAdded) {
              context.read<CarBloc>().add(FetchCars());
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(highlightedCircles: 2),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<CarBloc, CarState>(
                builder: (context, state) {
                  if (state is CarLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor, // Use theme primary color
                      ),
                    );
                  } else if (state is CarError) {
                    return Center(
                      child: Text(
                        "Error loading cars: ${state.message}",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (state is CarLoaded) {
                    return _buildCarSelection();
                  }
                  return Container(); // Default empty state
                },
              ),
              SizedBox(height: 20.h),
              _buildSeatsControl(),
              SizedBox(height: 20.h),
              _buildGenderToggle(),
              SizedBox(height: 20.h),
              _buildPaymentMethod(),
              const Spacer(),
              _buildNextButton(),
              SizedBox(height: 70.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarSelection() {
    return Card(
      color: ThemeColors.backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_car, color: ThemeColors.primaryColor, size: 24.w),
                SizedBox(width: 8.w),
                Text(
                  'Select Vehicle',
                  style: AppFonts.bodyTextStyle.copyWith(
                    fontSize: AppFonts.body1TextSize,
                    color: ThemeColors.headlinesTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            BlocBuilder<CarBloc, CarState>(
              builder: (context, carState) {
                return BlocBuilder<CarPreferencesBloc, CarPreferencesState>(
                  builder: (context, prefState) {
                    if (carState is CarInitial || carState is CarLoading || prefState is CarPreferencesInitial || prefState is CarPreferencesLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: ThemeColors.progressIndicatorColor,
                        ),
                      );
                    }
                    if (carState is CarError) {
                      print('Error loading cars: ${carState.message}');
                      return Text(
                        'Please try again later',
                        style: AppFonts.bodyTextStyle.copyWith(
                          color: ThemeColors.accentColor,
                          fontSize: AppFonts.body2TextSize,
                        ),
                      );
                    }
                    if (carState is CarLoaded) {
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.w),
                                border: Border.all(
                                  color: ThemeColors.primaryColorLight.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _selectedCarId,
                                dropdownColor: ThemeColors.canvasColor,
                                menuMaxHeight: 300.h,
                                style: AppFonts.bodyTextStyle.copyWith(
                                  fontSize: AppFonts.body1TextSize,
                                  color: ThemeColors.headlinesTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                borderRadius: BorderRadius.circular(12.w),
                                elevation: 6,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                                  hintText: 'Choose your vehicle',
                                  hintStyle: AppFonts.bodyTextStyle.copyWith(
                                    color: ThemeColors.hintTextColor,
                                  ),
                                ),
                                selectedItemBuilder: (BuildContext context) {
                                  return carState.cars.map<Widget>((CarEntity car) {
                                    return Text('${car.company} ${car.model}');
                                  }).toList();
                                },
                                items: carState.cars.map((car) {
                                  return DropdownMenuItem<String>(
                                    value: car.numberPlate,
                                    child: Row(
                                      children: [
                                        Icon(Icons.directions_car, color: ThemeColors.primaryColor),
                                        SizedBox(width: 12.w),
                                        Text('${car.company} ${car.model}'),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) => _updateCarPreference(value),
                                icon: Icon(Icons.arrow_drop_down, color: ThemeColors.primaryColor),
                              ),
                            
                            ),
                          ),
                          SizedBox(width: 12.w),
                          _buildAddCarButton(),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            ),
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
          onTap: _showAddCarModal,
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

  Widget _buildSeatsControl() {
    return Card(
      color: ThemeColors.backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event_seat, color: ThemeColors.primaryColor, size: 24.w),
                SizedBox(width: 8.w),
                Text(
                  'Available Seats',
                  style: AppFonts.bodyTextStyle.copyWith(
                    fontSize: AppFonts.body1TextSize,
                    color: ThemeColors.headlinesTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ThemeColors.primaryColorDark.withOpacity(0.75),
                      ThemeColors.primaryColor.withOpacity(0.8),
                      ThemeColors.primaryColorDark.withOpacity(0.75),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: Colors.white),
                      iconSize: 28.w,
                      onPressed: () => _updateSeats(_availableSeats - 1),
                    ),
                    Container(
                      width: 80.w,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Center(
                        child: Text(
                          '$_availableSeats',
                          style: AppFonts.headlineTextStyle.copyWith(
                            fontSize: AppFonts.headline3TextSize,
                            color: ThemeColors.primaryColorDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      iconSize: 28.w,
                      onPressed: () => _updateSeats(_availableSeats + 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderToggle() {
    return Card(
      color: ThemeColors.backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.people_alt, color: ThemeColors.primaryColor, size: 24.w),
                SizedBox(width: 12.w),
                Text(
                  'Same Gender Only',
                  style: AppFonts.bodyTextStyle.copyWith(
                    fontSize: AppFonts.body1TextSize,
                    color: ThemeColors.headlinesTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Switch.adaptive(
              value: _sameGenderOnly,
              onChanged: (value) => _updateGenderPreference(value),
              activeColor: Colors.white,
              activeTrackColor: ThemeColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return GradientButton(
      onTap: _handleNextPressed,
      text: 'Confirm Schedule',
    );
  }

  Widget _buildPaymentMethod() {
    return Card(
      color: ThemeColors.backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.payment, color: ThemeColors.primaryColor, size: 24.w),
                SizedBox(width: 8.w),
                Text(
                  'Payment Method',
                  style: AppFonts.bodyTextStyle.copyWith(
                    fontSize: AppFonts.body1TextSize,
                    color: ThemeColors.headlinesTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildPaymentOption(
                    title: 'Cash',
                    isSelected: _selectedPaymentMethod == 'cash',
                    onTap: () => _updatePayment('cash'),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildPaymentOption(
                    title: 'Free',
                    isSelected: _selectedPaymentMethod == 'free',
                    onTap: () => _updatePayment('free'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? ThemeColors.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(
            color: isSelected ? ThemeColors.primaryColor : ThemeColors.primaryColorLight.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: AppFonts.bodyTextStyle.copyWith(
              color: ThemeColors.headlinesTextColor,
              // color: isSelected ? ThemeColors.primaryColor : ThemeColors.headlinesTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }



  void _updateLocalState(CarPreferencesEntity preferences) {
    setState(() {
      _selectedCarId = preferences.selectedCar;
      _availableSeats = preferences.availableSeats;
      _sameGenderOnly = preferences.sameGenderOnly;
      _selectedPaymentMethod = preferences.payment; 
    });
  }

  void _updateCarPreference(String? carId) {
    context.read<CarPreferencesBloc>().add(
      SaveCarPreferencesEvent(
        CarPreferencesEntity(
          selectedCar: carId,
          availableSeats: _availableSeats,
          sameGenderOnly: _sameGenderOnly,
          payment: _selectedPaymentMethod,
        ),
      ),
    );
  }

  void _updatePayment(String option) {
    context.read<CarPreferencesBloc>().add(
      SaveCarPreferencesEvent(
        CarPreferencesEntity(
          selectedCar: _selectedCarId,
          availableSeats: _availableSeats,
          sameGenderOnly: _sameGenderOnly,
          payment: option,
        ),
      ),
    );
  }

  void _updateSeats(int newValue) {
    if (newValue < 1 || newValue > 6) return;
    context.read<CarPreferencesBloc>().add(
      SaveCarPreferencesEvent(
        CarPreferencesEntity(
          selectedCar: _selectedCarId,
          availableSeats: newValue,
          sameGenderOnly: _sameGenderOnly,
          payment: _selectedPaymentMethod,
        ),
      ),
    );
  }

  void _updateGenderPreference(bool value) {
    context.read<CarPreferencesBloc>().add(
      SaveCarPreferencesEvent(
        CarPreferencesEntity(
          selectedCar: _selectedCarId,
          availableSeats: _availableSeats,
          sameGenderOnly: value,
          payment: _selectedPaymentMethod,
        ),
      ),
    );
  }

  void _handleNextPressed() {
    final preferences = CarPreferencesEntity(
      selectedCar: _selectedCarId,
      availableSeats: _availableSeats,
      sameGenderOnly: _sameGenderOnly,
      payment: _selectedPaymentMethod,
    );

    context.read<CarPreferencesBloc>().add(
      SaveCarPreferencesEvent(preferences),
    );

    Navigator.pushNamed(
      context,
      Routes.d3,
      // arguments: {
      //   ...widget.scheduleData,
      //   'carPreferences': preferences.toMap(),
      // },
    );
  }

  _showAddCarModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2C2C2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        final TextEditingController carCompanyController = TextEditingController();
        final TextEditingController carModelController = TextEditingController();
        final TextEditingController carColorController = TextEditingController();
        final TextEditingController carNumberPlateController = TextEditingController();
        final TextEditingController carMileageController = TextEditingController();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Car',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCarInputField(carCompanyController, 'Car Company'),
                _buildCarInputField(carModelController, 'Car Model'),
                _buildCarInputField(carColorController, 'Car Color'),
                _buildCarInputField(carNumberPlateController, 'Car Number Plate'),
                _buildCarInputField(
                  carMileageController,
                  'Car Mileage',
                  keyboardType: TextInputType.number, 
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly], 
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: GradientButton(
                    onTap: () {
                      final car = CarEntity(
                        company: carCompanyController.text,
                        model: carModelController.text,
                        color: carColorController.text,
                        numberPlate: carNumberPlateController.text,
                        mileage: double.tryParse(carMileageController.text) ?? 0.0,
                        isVerified: false,
                      );
                      BlocProvider.of<CarBloc>(context).add(AddCar(car));
                      Navigator.pop(context);
                    },
                    text: 'Add Car',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildCarInputField(
    TextEditingController controller, 
    String label, {
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Color(0xFFEC8825),
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

}
