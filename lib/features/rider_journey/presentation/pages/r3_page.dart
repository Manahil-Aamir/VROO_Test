import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vroo_test/features/rider_journey/presentation/bloc/bloc/r3_bloc.dart';
import 'package:vroo_test/features/rider_journey/presentation/bloc/state/r3_state.dart';
import 'package:vroo_test/shared/widgets/build_detail_card.dart';
import 'package:vroo_test/shared/widgets/build_detail_tile.dart';
import 'package:vroo_test/shared/widgets/custom_app_bar.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../data/model/preferences_model.dart';
import '../../data/model/schedule_model.dart';
import '../bloc/event/r3_event.dart';

class R3Page extends StatefulWidget {
  final ScheduleModel schedule;
  final PreferencesModel preferences;

  const R3Page({
    super.key,
    required this.schedule,
    required this.preferences,
  });

  @override
  State<R3Page> createState() => _R3PageState();
}

class _R3PageState extends State<R3Page> {
  LatLng? sourceCoordinates;
  LatLng? destinationCoordinates;

  @override
  void initState() {
    super.initState();
    final rideBloc = context.read<R3Bloc>();
    rideBloc.add(GetCoordinatesEvent(
      placeId: widget.schedule.fromPlaceId,
      isSource: true,
    ));
    rideBloc.add(GetCoordinatesEvent(
      placeId: widget.schedule.toPlaceId,
      isSource: false,
    ));
  }

  // Helper methods for formatting times.
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final hours = timeOfDay.hour.toString().padLeft(2, '0');
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
    return "$hours:$minutes:00";
  }

  String formatISO8601DateTime(DateTime date, TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    const seconds = "00"; // Default seconds to 00
    final dateString = date.toIso8601String().split('T')[0];
    return "${dateString}T$hours:$minutes:$seconds";
  }

  String generateRandomDriverId() {
    final random = Random();
    return 'Test ${random.nextInt(100)}';
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the Scaffold with a MultiProvider so that DI is available.
    print('walk: ${widget.preferences.walk}');
    print('gender: ${widget.preferences.sameGender}');
    // print('fromPlaceId: ${widget.schedule.fromPlaceId}');
    // print('toPlaceId: ${widget.schedule.toPlaceId}');
    // print('fromDescription: ${widget.schedule.fromDescription}');
    // print('toDescription: ${widget.schedule.toDescription}');
    // print('date: ${widget.schedule.date}');
    // print('minTime: ${widget.schedule.minTime}');
    // print('maxTime: ${widget.schedule.maxTime}');
    // print('arrivalTime: ${widget.schedule.arrivalTime}');
    // print('recurrenceType: ${widget.schedule.recurrenceType}');
    return Scaffold(
      appBar: CustomAppBar(
        highlightedCircles: 3,
        totalCircles: 3,
      ),
      body: BlocListener<R3Bloc, R3State>(
        listener: (context, state) {
          if (state is CoordinatesLoaded) {
            setState(() {
              if (state.isSource) {
                sourceCoordinates = state.coordinates;
              } else {
                destinationCoordinates = state.coordinates;
              }
            });
          } else if (state is RideRequestSuccess) {
            final response = state.response;
            print('Response: $response');
            final rideRequestId = response['rideRequestId'];
            final List<dynamic> matchingRides = response['matchingRides'];
            print('Matching Rides on R3: $matchingRides');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Ride created successfully! ID: $rideRequestId')),
            );
            context
                .read<Navigation>()
                .navigateTo('/booking_confirm', arguments: {
              'rideRequestId': rideRequestId,
              'matchingRides': matchingRides,
              'minPickupTime': widget.schedule.minTime,
              'maxPickupTime': widget.schedule.maxTime,
              'schedule': widget.schedule,
              'preferences': widget.preferences,
              'source': sourceCoordinates,
              'destination': destinationCoordinates,
            });
          } else if (state is RideRequestFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${runtimeType.toString()}')),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DetailCard(
                        title: 'Trip Details',
                        details: [
                          DetailTile(
                            icon: Icons.location_on,
                            label: 'From',
                            value: widget.schedule.fromDescription,
                          ),
                          DetailTile(
                            icon: Icons.flag,
                            label: 'To',
                            value: widget.schedule.toDescription,
                          ),
                          DetailTile(
                            icon: Icons.calendar_today,
                            label: 'Date',
                            value:
                                '${widget.schedule.date.day}/${widget.schedule.date.month}/${widget.schedule.date.year}',
                          ),
                          DetailTile(
                            icon: Icons.access_time,
                            label: 'Min Time',
                            value:
                                '${widget.schedule.minTime.hour}:${widget.schedule.minTime.minute}',
                          ),
                          DetailTile(
                            icon: Icons.access_time,
                            label: 'Max Time',
                            value:
                                '${widget.schedule.maxTime.hour}:${widget.schedule.maxTime.minute}',
                          ),
                          DetailTile(
                            icon: Icons.access_time,
                            label: 'Max Arrival Time',
                            value: widget.schedule.arrivalTime != null
                                ? '${widget.schedule.arrivalTime.hour}:${widget.schedule.arrivalTime.minute}'
                                : 'Not set',
                          ),
                          DetailTile(
                            icon: Icons.repeat,
                            label: 'Recurrence',
                            value: widget.schedule.recurrenceType,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DetailCard(
                        title: 'Preferences',
                        details: [
                          DetailTile(
                            icon: Icons.person,
                            label: 'Same Gender',
                            value: widget.preferences.sameGender ? 'Yes' : 'No',
                          ),
                          DetailTile(
                            icon: Icons.directions_walk,
                            label: 'Prefer Walk',
                            value: widget.preferences.walk ? 'Yes' : 'No',
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      GradientButton(
                        onTap: () {
                          // Ensure coordinates have been loaded.
                          if (sourceCoordinates == null ||
                              destinationCoordinates == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Coordinates are not yet loaded.')),
                            );
                            return;
                          }
                          final formattedMinTime = formatISO8601DateTime(
                            widget.schedule.date,
                            widget.schedule.minTime,
                          );
                          final formattedMaxTime = formatISO8601DateTime(
                            widget.schedule.date,
                            widget.schedule.maxTime,
                          );
                          final rideData = {
                            "riderId": generateRandomDriverId(),
                            "source": {
                              "coords": [
                                sourceCoordinates!.latitude,
                                sourceCoordinates!.longitude
                              ],
                              "placeId": widget.schedule.fromPlaceId,
                              "address": widget.schedule.fromDescription,
                            },
                            "destination": {
                              "coords": [
                                destinationCoordinates!.latitude,
                                destinationCoordinates!.longitude
                              ],
                              "placeId": widget.schedule.toPlaceId,
                              "address": widget.schedule.toDescription,
                            },
                            "date": DateFormat("yyyy-MM-dd").format(
                              DateTime(
                                widget.schedule.date.year,
                                widget.schedule.date.month,
                                widget.schedule.date.day,
                              ),
                            ),
                            "pickupTimeRange": {
                              "min": formatISO8601DateTime(
                                widget.schedule.date,
                                widget.schedule.minTime,
                              ),
                              "max": formatISO8601DateTime(
                                widget.schedule.date,
                                widget.schedule.maxTime,
                              ),
                            },
                            "maxArrivalTime": formatISO8601DateTime(
                              widget.schedule.date,
                              widget.schedule.arrivalTime,
                            ),
                            "preferences": {
                              "maleOnly": !widget.preferences.sameGender,
                              "femaleOnly": widget.preferences.sameGender,
                              "canWalk": widget.preferences.walk,
                            },
                            "isRecurring": false,
                          };
                          print(rideData);
                          // Dispatch the ride request event.
                          context
                              .read<R3Bloc>()
                              .add(SendRideRequestEvent(rideData));
                        },
                        text: 'Confirm and Proceed',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
