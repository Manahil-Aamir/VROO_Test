import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/custom_app_bar.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/router/routes.dart';
import '../../domain/entity/car.dart';
import '../../domain/entity/driver_schedule2_entity.dart';
import '../bloc/bloc/car_bloc.dart';
import '../bloc/bloc/d2_bloc.dart';
import '../bloc/event/car_event.dart';
import '../bloc/event/d2_event.dart';
import '../bloc/state/car_state.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../bloc/state/d2_state.dart';
import 'widgets/d2/add_car_modal.dart';
import 'widgets/d2/car_selection_widget.dart';
import 'widgets/d2/gender_toggle_widget.dart';
import 'widgets/d2/payment_option_widget.dart';
import 'widgets/d2/seats_control_widget.dart';

class D2Page extends StatefulWidget {
  final String fromPlaceId;
  final String toPlaceId;
  final String fromDescription;
  final String toDescription;
  final List<dynamic> selectedRouteCoords;
  final String routeDistance;
  final String routeDuration;
  final DateTime date;
  final TimeOfDay time;
  final TimeOfDay maxArrivalTime;
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
    required this.maxArrivalTime,
    required this.selectedRouteCoords,
    required this.recurrence,
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

    print('distance: ${widget.routeDistance}');
    print('duration: ${widget.routeDuration}');
    print('date: ${widget.date}');
    print('time: ${widget.time}');
    print('maxArrivalTime: ${widget.maxArrivalTime}');
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
                  return CarSelectionWidget(
                    selectedCarId: _selectedCarId,
                    onCarSelected: _updateCarPreference,
                    onAddCarPressed: _showAddCarModal,
                  );
                }
                return const SizedBox.shrink();
                  // return Container(); // Default empty state
                },
              ),
              SizedBox(height: 20.h),
              SeatsControlWidget(availableSeats: _availableSeats, onSeatsChanged: _updateSeats),
              SizedBox(height: 20.h),
              GenderToggleWidget(sameGenderOnly: _sameGenderOnly, onGenderToggled: _updateGenderPreference),
              SizedBox(height: 20.h),
              PaymentMethodWidget(selectedPaymentMethod: _selectedPaymentMethod, onPaymentSelected: _updatePayment),
              const Spacer(),
              GradientButton(
                onTap: _handleNextPressed,
                text: 'Next',
              ),
              SizedBox(height: 70.h),
            ],
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

    final carState = BlocProvider.of<CarBloc>(context).state;
  
    if (carState is! CarLoaded || _selectedCarId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a vehicle')),
      );
      return;
    }

    final selectedCar = carState.cars.firstWhere(
      (car) => car.numberPlate == _selectedCarId,
      orElse: () => CarEntity( // Fallback dummy car
        company: 'Unknown',
        model: 'Unknown',
        color: 'Unknown',
        numberPlate: 'Unknown',
        mileage: 0,
        isVerified: false,
      ),
    );

    print(widget.time);
    print(widget.date);
    print(widget.maxArrivalTime);
    print(widget.routeDistance);
    print(widget.routeDuration);

    context.read<Navigation>().navigateTo(
      Routes.d3,
      arguments: {
        'fromPlaceID': widget.fromPlaceId,
        'toPlaceID': widget.toPlaceId,
        'fromDescription': widget.fromDescription,
        'toDescription': widget.toDescription,
        'routeCoords': widget.selectedRouteCoords, // Corrected key
        'routeDistance': widget.routeDistance, // Corrected key
        'routeDuration': widget.routeDuration, // Corrected key
        'date': widget.date,
        'time': widget.time,
        'maxArrivalTime': widget.maxArrivalTime,
        'recurrence': widget.recurrence, // Added missing parameter
        'selectedCar': selectedCar,
        'availableSeats': _availableSeats,
        'sameGenderOnly': _sameGenderOnly, // Corrected key
        'paymentOption': [_selectedPaymentMethod], // Corrected key
      },
    );

    // Navigator.pushNamed(
    //   context,
    //   Routes.d3,
    //   arguments: {
    //     'fromPlaceID': widget.fromPlaceId,
    //     'toPlaceID': widget.toPlaceId,
    //     'fromDescription': widget.fromDescription,
    //     'toDescription': widget.toDescription,
    //     'routeCoords': widget.selectedRouteCoords, // Corrected key
    //     'routeDistance': widget.routeDistance, // Corrected key
    //     'routeDuration': widget.routeDuration, // Corrected key
    //     'date': widget.date,
    //     'time': widget.time,
    //     'maxArrivalTime': widget.maxArrivalTime,
    //     'recurrence': widget.recurrence, // Added missing parameter
    //     'selectedCar': selectedCar,
    //     'availableSeats': _availableSeats,
    //     'sameGenderOnly': _sameGenderOnly, // Corrected key
    //     'paymentOption': [_selectedPaymentMethod], // Corrected key
    //   },
    // );
  }

  void _showAddCarModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2C2C2C),
      builder: (context) => AddCarModal(
        onCarAdded: (newCar) {
          context.read<CarBloc>().add(AddCar(newCar));
        },
      ),
    );
  }

}
