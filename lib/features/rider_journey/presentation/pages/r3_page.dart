import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vroo_test/features/matching/data/models/matching_rides_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/ride_journey_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/source_and_dest_model.dart';
import 'package:vroo_test/features/rider_journey/presentation/bloc/bloc/r3_bloc.dart';
import 'package:vroo_test/features/rider_journey/presentation/bloc/state/r3_state.dart';
import 'package:vroo_test/shared/widgets/build_detail_card.dart';
import 'package:vroo_test/shared/widgets/build_detail_tile.dart';
import 'package:vroo_test/shared/widgets/custom_app_bar.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/expandable_detail_tile.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/overlay.dart';
import '../../../authentication/presentation/bloc/user_bloc.dart';
import '../../data/model/preferences_model.dart';
import '../../data/model/schedule_model.dart';
import '../bloc/event/r3_event.dart';

class R3Page extends StatefulWidget {
  final ScheduleModel schedule;
  final PreferencesModel preferences;
  final SourceAndDestModel location;

  const R3Page({
    super.key,
    required this.schedule,
    required this.preferences,
    required this.location,
  });

  @override
  State<R3Page> createState() => _R3PageState();
}

class _R3PageState extends State<R3Page> {
  late RiderJourneyModel rideDetails;

  @override
  void initState() {
    super.initState();
    final rideBloc = context.read<R3Bloc>();
    rideBloc.add(GetCoordinatesEvent(
      placeId: widget.location.fromPlaceId,
      isSource: true,
    ));
    rideBloc.add(GetCoordinatesEvent(
      placeId: widget.location.toPlaceId,
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

  String getRiderId() {
    final FirebaseAuth firebaseAuth =
        FirebaseAuth.instance; // Initialize FirebaseAuth
    final User user = firebaseAuth.currentUser!; // Get current user
    return user.uid; // Return UID or null if user is not logged in
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print('walk: ${widget.preferences.walk}');
    print('gender: ${widget.preferences.sameGender}');

    return Scaffold(
      appBar: CustomAppBar(
        highlightedCircles: 3,
      ),
      body: BlocBuilder<R3Bloc, R3State>(
        builder: (context, state) {
          return Stack(
            children: [
              BlocListener<R3Bloc, R3State>(
                listener: (context, state) {
                  if (state is CoordinatesLoaded) {
                    setState(() {
                      if (state.isSource) {
                        widget.location.sourceCoordinates = state.coordinates;
                      } else {
                        widget.location.destCoordinates = state.coordinates;
                      }
                    });
                  } else if (state is RideRequestSuccess) {
                    RideResponseModel response = state.response;
                    final rideRequestId = response.data.rideRequestId;
                    print('success');
                    print('Ride request ID: $rideRequestId');
                    final List<MatchingRideModel> matchingRides =
                        response.data.matchingRides;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: theme.secondaryHeaderColor,
                          content: Text('Ride created successfully!')),
                    );
                    print('schedule: ${widget.schedule.toMap()}');
                    context
                        .read<Navigation>()
                        .navigateTo('/booking_confirm', arguments: {
                      'rideRequestId': rideRequestId,
                      'matchingRides': matchingRides,
                      'schedule': widget.schedule,
                      'maxPickupTime': widget.schedule.maxTime,
                      'minPickupTime': widget.schedule.minTime,
                    });
                  } else if (state is RideRequestFailure) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text('Error: ${runtimeType.toString()}')),
                    // );
                    print('Error: ${state.error}');
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(16.0.w),
                          child: Column(
                            children: [
                              DetailCard(
                                title: 'Trip Details',
                                details: [
                                  ExpandableDetailTile(
                                    icon: Icons.location_on,
                                    label: 'From',
                                    value: widget.location.fromDescription,
                                  ),
                                  ExpandableDetailTile(
                                    icon: Icons.flag,
                                    label: 'To',
                                    value: widget.location.toDescription,
                                  ),
                                  DetailTile(
                                    icon: Icons.calendar_today,
                                    label: 'Date',
                                    value:
                                        '${widget.schedule.date.day}/${widget.schedule.date.month}/${widget.schedule.date.year}',
                                  ),
                                  DetailTile(
                                    icon: Icons.access_time,
                                    label: 'Pick Up Time',
                                    value:
                                        '${widget.schedule.minTime.hour}:${widget.schedule.minTime.minute.toString().padLeft(2, '0')} - ${widget.schedule.maxTime.hour}:${widget.schedule.maxTime.minute.toString().padLeft(2, '0')}',
                                  ),
                                  DetailTile(
                                    icon: Icons.access_time,
                                    label: 'Max Arrival Time',
                                    value:
                                        '${widget.schedule.arrivalTime.hour}:${widget.schedule.arrivalTime.minute == 0 ? '00' : widget.schedule.arrivalTime.minute}',
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              DetailCard(
                                title: 'Preferences',
                                details: [
                                  DetailTile(
                                    icon: Icons.person,
                                    label: 'Same Gender',
                                    value: widget.preferences.sameGender
                                        ? 'Yes'
                                        : 'No',
                                  ),
                                  DetailTile(
                                    icon: Icons.directions_walk,
                                    label: 'Prefer Walk',
                                    value:
                                        widget.preferences.walk ? 'Yes' : 'No',
                                  ),
                                ],
                              ),
                              SizedBox(height: 60.h),
                              GradientButton(
                                onTap: () {
                                  _onConfirmPressed();
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
              // Show loading overlay when state is RideRequestLoading
              if (state is RideRequestLoading) const CustomOverlay(),
            ],
          );
        },
      ),
    );
  }

  void _onConfirmPressed() {
    if (widget.location.sourceCoordinates == null ||
        widget.location.destCoordinates == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please wait while coordinates are loading.')),
      );
      return;
    }

    final userState = context.read<UserBloc>().state;
    String userGender = '';
    bool maleOnly = false;
    bool femaleOnly = false;

    if (userState is UserLoaded) {
      print('here');
      print(userState.user);
      userGender = userState.user.gender;
    }
    print('user gender: $userGender');
    print('same gender: ${widget.preferences.sameGender}');

    if (userGender.toLowerCase() == 'female' &&
        widget.preferences.sameGender == true) {
      femaleOnly = true;
    } else if (userGender.toLowerCase() == 'male' &&
        widget.preferences.sameGender == true) {
      maleOnly = true;
    }

    rideDetails = RiderJourneyModel(
      riderId: getRiderId(),
      source: RideLocationModel(
        coords: [
          widget.location.sourceCoordinates!.latitude,
          widget.location.sourceCoordinates!.longitude
        ],
        placeId: widget.location.fromPlaceId,
        address: widget.location.fromDescription,
      ),
      destination: RideLocationModel(
        coords: [
          widget.location.destCoordinates!.latitude,
          widget.location.destCoordinates!.longitude
        ],
        placeId: widget.location.toPlaceId,
        address: widget.location.toDescription,
      ),
      date: DateFormat("yyyy-MM-dd").format(
        DateTime(
          widget.schedule.date.year,
          widget.schedule.date.month,
          widget.schedule.date.day,
        ),
      ),
      pickupTimeRange: PickupTimeRangeModel(
        min: formatISO8601DateTime(
            widget.schedule.date, widget.schedule.minTime),
        max: formatISO8601DateTime(
            widget.schedule.date, widget.schedule.maxTime),
      ),
      maxArrivalTime: formatISO8601DateTime(
          widget.schedule.date, widget.schedule.arrivalTime),
      preferences: RidePreferencesModel(
        maleOnly: maleOnly,
        femaleOnly: femaleOnly,
        canWalk: widget.preferences.walk,
      ),
      isRecurring: false,
    );

    print('Ride data: ${rideDetails.toJson()}');

    context.read<R3Bloc>().add(SendRideRequestEvent(rideDetails));
  }
}
