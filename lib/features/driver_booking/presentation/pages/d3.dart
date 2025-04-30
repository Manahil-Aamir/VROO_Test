import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/error_dialog.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../authentication/presentation/bloc/user_bloc.dart';
import '../../../cars/domain/entity/car.dart';
import '../../domain/entity/ride_request.dart';
import '../bloc/bloc/d3_bloc.dart';
import '../bloc/event/d3_event.dart';
import '../bloc/state/d3_state.dart';
import 'package:vroo_test/shared/widgets/build_detail_card.dart';
import 'package:vroo_test/shared/widgets/build_detail_tile.dart';
import '../../../../shared/widgets/expandable_detail_tile.dart';
import 'widgets/d3/loading_overlay.dart';

class D3 extends StatelessWidget {
  final String fromDescription;
  final String fromPlaceId;
  final String toDescription;
  final String toPlaceId;
  final List<dynamic> routeCoords;
  final DateTime date;
  final TimeOfDay time;
  final TimeOfDay maxArrivalTime;
  final String recurrence;
  final CarEntity selectedCar;
  final int availableSeats;
  final bool sameGenderOnly;
  final List<String> paymentOption;
  final String routeDistance;
  final String routeDuration;

  const D3({
    super.key,
    required this.fromDescription,
    required this.fromPlaceId,
    required this.toDescription,
    required this.toPlaceId,
    required this.routeCoords,
    required this.date,
    required this.time,
    required this.maxArrivalTime,
    required this.recurrence,
    required this.selectedCar,
    required this.availableSeats,
    required this.sameGenderOnly,
    required this.paymentOption,
    required this.routeDistance,
    required this.routeDuration,
  });

  // init method to print all the variables
  void init() {
    printVariables();
  }  


  void printVariables() {
    print('Selected Car Details:');
    print('Company: ${selectedCar.company}');
    print('Model: ${selectedCar.model}');
    print('Color: ${selectedCar.color}');
    print('License Plate: ${selectedCar.numberPlate}');
    // Add any other properties of CarEntity that you want to print
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RideBloc, RideState>(
      listener: (context, state) {
        if (state is RideSubmitted) {
          print('here');
          context.read<Navigation>().navigateTo(
                '/booking_confirm_driver',
              );
        }
        if (state is RideSubmissionFailed) {
          ErrorDialog.show(context, state.error);
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          highlightedCircles: 3,
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Trip Details Card
                        DetailCard(
                          title: 'Trip Details',
                          details: [
                            ExpandableDetailTile(
                              icon: Icons.location_on,
                              label: 'From',
                              value: fromDescription,
                              // onTap: () => _showDetailBottomSheet(context, 'From', fromDescription),
                            ),
                            ExpandableDetailTile(
                              icon: Icons.flag,
                              label: 'To',
                              value: toDescription,
                              // onTap: () => _showDetailBottomSheet(context, 'To', toDescription),
                            ),
                            DetailTile(
                              icon: Icons.calendar_today,
                              label: 'Date',
                              value: '${date.day}/${date.month}/${date.year}',
                            ),
                            DetailTile(
                              icon: Icons.access_time,
                              label: 'Departure Time',
                              value:
                                  '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                            ),
                            DetailTile(
                              icon: Icons.access_time,
                              label: 'Max Arrival Time',
                              value:
                                  '${maxArrivalTime.hour}:${maxArrivalTime.minute.toString().padLeft(2, '0')}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Car and Seats Card
                        DetailCard(
                          title: 'Car and Seats',
                          details: [
                            DetailTile(
                              icon: Icons.directions_car,
                              label: 'Selected Car',
                              value:
                                  '${selectedCar.company} ${selectedCar.model}',
                            ),
                            DetailTile(
                              icon: Icons.event_seat,
                              label: 'Available Seats',
                              value: '$availableSeats',
                            ),
                            DetailTile(
                              icon: Icons.person,
                              label: 'Same Gender',
                              value: sameGenderOnly ? 'Yes' : 'No',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Payment Card
                        DetailCard(
                          title: 'Payment',
                          details: [
                            DetailTile(
                              icon: Icons.payment,
                              label: 'Payment Option',
                              value: paymentOption.map((option) => 
                                option.isNotEmpty ? 
                                  option[0].toUpperCase() + option.substring(1) : 
                                  option)
                                .join(', '),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Confirm Button
                        GradientButton(
                          onTap: () => _submitRideRequest(context),
                          text: 'Confirm and Proceed',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Loading Overlay
            BlocBuilder<RideBloc, RideState>(
              builder: (context, state) => LoadingOverlay(
                visible: state is RideSubmitting,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRideRequest(BuildContext context) {
    final departureDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final maxArrivalDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      maxArrivalTime.hour,
      maxArrivalTime.minute,
    );

    final user = FirebaseAuth.instance.currentUser;
    final userState = context.read<UserBloc>().state;
    String user_gender = '';
    bool maleOnly = false;
    bool femaleOnly = false;

    if (userState is UserLoaded) {
      user_gender = userState.user.gender;
    }
    print('user gender: ${user_gender}');
    print('same gender: $sameGenderOnly');

    if (user_gender.toLowerCase() == 'female' && sameGenderOnly == true) {
      femaleOnly = true;
    } else if (user_gender.toLowerCase() == 'male' && sameGenderOnly == true) {
      maleOnly=true;
    }

    final rideRequest = RideRequest(
      driverId: user!.uid, //remove when token
      numOfSeats: availableSeats,
      car: selectedCar,
      source: {
        'address': fromDescription,
        'placeId': fromPlaceId,
        'coords': LatLng(routeCoords.first[0], routeCoords.first[1]),
      },
      destination: {
        'address': toDescription,
        'placeId': toPlaceId,
        'coords': LatLng(routeCoords.last[0], routeCoords.last[1]),
      },
      preference: preference_driver(maleOnly: maleOnly, femaleOnly: femaleOnly),
      // samegender: sameGenderOnly,
      departureTime: departureDateTime.toIso8601String(),
      maxArrivalTime: maxArrivalDateTime.toIso8601String(),
      distance: _parseDistance(routeDistance),
      duration: _parseDuration(routeDuration),
      date: date.toIso8601String(),
      paymentMethod: paymentOption,
      coords: routeCoords,
    );

    print('ride create: $rideRequest');

    context.read<RideBloc>().add(SubmitRide(rideRequest));
  }

  double _parseDistance(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.parse(cleaned) * 1000;
  }

  int _parseDuration(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(cleaned) * 60;
  }
}
