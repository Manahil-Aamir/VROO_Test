import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/router/routes.dart';
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
        appBar: AppBar(
          title: const Text('Vehicle Preferences'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCarSelection(),
              SizedBox(height: 20.h),
              _buildSeatsControl(),
              SizedBox(height: 20.h),
              _buildGenderToggle(),
              const Spacer(),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarSelection() {
    return BlocBuilder<CarBloc, CarState>(
      builder: (context, carState) {
        return BlocBuilder<CarPreferencesBloc, CarPreferencesState>(
          builder: (context, prefState) {
            if (carState is CarLoading || prefState is CarPreferencesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (carState is CarError) {
              return Text('Error loading cars: ${carState.message}');
            }

            if (carState is CarLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Vehicle:'),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCarId,
                          items: carState.cars.map((car) {
                            return DropdownMenuItem<String>(
                              value: car.numberPlate,
                              child: Text('${car.company} ${car.model}'),
                            );
                          }).toList(),
                          onChanged: (value) => _updateCarPreference(value),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.w),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      _buildAddCarButton(),
                    ],
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildAddCarButton() {
    return Container(
      width: 40.w,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: IconButton(
        icon: const Icon(Icons.add),
        onPressed: _showAddCarModal,
      ),
    );
  }

  Widget _buildSeatsControl() {
    return Row(
      children: [
        const Text('Available Seats:'),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => _updateSeats(_availableSeats - 1),
        ),
        Text('$_availableSeats'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _updateSeats(_availableSeats + 1),
        ),
      ],
    );
  }

  Widget _buildGenderToggle() {
    return Row(
      children: [
        const Text('Same Gender Only:'),
        Switch(
          value: _sameGenderOnly,
          onChanged: (value) => _updateGenderPreference(value),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return GradientButton(
      onTap: _handleNextPressed,
      text: 'Confirm Schedule',
    );
  }

  void _updateLocalState(CarPreferencesEntity preferences) {
    setState(() {
      _selectedCarId = preferences.selectedCar;
      _availableSeats = preferences.availableSeats;
      _sameGenderOnly = preferences.sameGenderOnly;
    });
  }

  void _updateCarPreference(String? carId) {
    context.read<CarPreferencesBloc>().add(
      SaveCarPreferencesEvent(
        CarPreferencesEntity(
          selectedCar: carId,
          availableSeats: _availableSeats,
          sameGenderOnly: _sameGenderOnly,
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
        ),
      ),
    );
  }

  void _handleNextPressed() {
    final preferences = CarPreferencesEntity(
      selectedCar: _selectedCarId,
      availableSeats: _availableSeats,
      sameGenderOnly: _sameGenderOnly,
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

  void _showAddCarModal() {
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
                _buildCarInputField(carMileageController, 'Car Mileage'),
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
                        mileage: double.tryParse(carMileageController.text) ?? 0,
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

  Widget _buildCarInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
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
