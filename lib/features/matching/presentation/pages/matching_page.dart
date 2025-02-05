import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:vroo_test/features/rider_journey/data/model/schedule_model.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/zigzag.dart';
import '../../../rider_journey/data/model/preferences_model.dart';
import '../../dependency_injection/matching_di.dart';
import '../bloc/bloc/matching_bloc.dart';
import '../bloc/event/matching_event.dart';
import '../bloc/state/matching_state.dart';
import '../widgets/matching_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
// Import your additional dependencies (e.g., LatLng, ScheduleModel, PreferencesModel, etc.)

class MatchingPage extends StatefulWidget {
  final String rideRequestId;
  final List<dynamic> initialMatchingRides;
  final TimeOfDay minPickupTime;
  final TimeOfDay maxPickupTime;
  final LatLng source;
  final LatLng destination;
  final ScheduleModel schedule;
  final PreferencesModel preferences;

  const MatchingPage({
    super.key,
    required this.rideRequestId,
    required this.initialMatchingRides,
    required this.minPickupTime,
    required this.maxPickupTime,
    required this.source,
    required this.destination,
    required this.schedule,
    required this.preferences,
  });

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  late int currentWindow;

  @override
  void initState() {
    super.initState();
    // Calculate the initial time window for UI purposes.
    final minTimeInMinutes =
        widget.minPickupTime.hour * 60 + widget.minPickupTime.minute;
    final maxTimeInMinutes =
        widget.maxPickupTime.hour * 60 + widget.maxPickupTime.minute;
    currentWindow = maxTimeInMinutes - minTimeInMinutes;
  }

  /// Formats a given [date] and [time] into an ISO8601 string using the provided pattern.
  String formatISO8601DateTime(DateTime date, TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    const seconds = "00"; // Fixed seconds
    final dateString = DateFormat("yyyy-MM-dd").format(date);
    return "${dateString}T$hours:$minutes:$seconds";
  }

  /// Adjust the local time window and trigger the API call.
  void _modifyTimeWindow(int adjustment) {
    try {
      setState(() {
        currentWindow = (currentWindow + adjustment).clamp(0, 60);
      });
      final int totalMinutes =
          widget.minPickupTime.minute + (currentWindow % 60);
      final int extraHours = (widget.minPickupTime.hour +
              (currentWindow ~/ 60) +
              (totalMinutes ~/ 60)) %
          24;
      final int adjustedMinutes = totalMinutes % 60;

      final adjustedMaxTime = TimeOfDay(
        hour: extraHours,
        minute: adjustedMinutes,
      );

      final modifyData = {
        "pickupTimeRange": {
          "min": formatISO8601DateTime(
              widget.schedule.date, widget.schedule.minTime),
          "max": formatISO8601DateTime(widget.schedule.date, adjustedMaxTime),
        },
      };

      print(modifyData);

      print("Sending ModifyTimeWindowEvent with modifyData: $modifyData");

      context.read<MatchingBloc>().add(ModifyTimeWindowEvent(
          id: widget.rideRequestId, modifyData: modifyData));
    } catch (e, stackTrace) {
      print('Error modifying time window: $e');
    }
  }

  /// Parses and formats an arrival time string.
  String formatArrivalTime(String? arrivalTime) {
    if (arrivalTime == null) return 'Unknown';
    try {
      String cleanedTime = arrivalTime.replaceAll(' GMT', '');
      DateFormat inputFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss");
      DateTime parsedDate = inputFormat.parse(cleanedTime);
      return DateFormat.jm().format(parsedDate);
    } catch (e) {
      print('Error parsing expectedArrivalTime: $e');
      return 'Unknown';
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print("🚀 MatchingPage initialized with:");
    print("rideRequestId: ${widget.rideRequestId}");
    print("initialMatchingRides: ${widget.initialMatchingRides}");
    print("minPickupTime: ${widget.minPickupTime}");
    print("maxPickupTime: ${widget.maxPickupTime}");
    print("source: ${widget.source}");
    print("destination: ${widget.destination}");
    print("schedule: ${widget.schedule}");
    print("preferences: ${widget.preferences}");

    return Scaffold(
      appBar: appBar(
        heading: 'Matching Rides',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: theme.cardColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.w)),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Row
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                color: theme.primaryColor, size: 24.w),
                            SizedBox(width: 8.w),
                            Text(
                              'Time Window',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: theme.primaryColorDark,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Time Adjustment Controls
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.75),
                                  Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.8),
                                  Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.75),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.w),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove,
                                      color: theme.scaffoldBackgroundColor),
                                  onPressed: () => _modifyTimeWindow(-5),
                                ),
                                Container(
                                  width: 80.w,
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(8.w),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$currentWindow mins',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.primaryColorDark,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add,
                                      color: theme.scaffoldBackgroundColor),
                                  onPressed: () => _modifyTimeWindow(5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocListener<MatchingBloc, MatchingState>(
              listener: (context, state) {
                if (state is RiderJoinSuccess) {
                  // Show a success SnackBar when the join is successful.
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Request Sent Successfully'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  });
                  context.read<Navigation>().navigateTo('/riderhome');
                } else if (state is RiderRequestError) {
                  // Show an error SnackBar when there's an error.
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${state.error}'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  });
                }
              },
              child: BlocBuilder<MatchingBloc, MatchingState>(
                builder: (context, state) {
                  if (state is RiderRequestLoading ||
                      state is RiderJoinLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RiderRequestLoaded) {
                    print('loadinggggggggggg');
                    print(state.matchingRides);
                    return ListView.builder(
                      itemCount: state.matchingRides.length,
                      itemBuilder: (context, index) {
                        try {
                          final ride = state.matchingRides[index];
                          if (ride is Map<String, dynamic>) {
                            return MatchCard(
                              driverName: ride['driverId'] ?? 'Unknown Driver',
                              rating: 4.3,
                              trips: 5,
                              source:
                                  widget.schedule.fromDescription ?? 'Unknown',
                              destination:
                                  ride['destination']?['address'] ?? 'Unknown',
                              fare: ride['fare'] ?? 0,
                              carModel: ride['car']['model'] ?? 'Unknown',
                              totalSeats: ride['numOfSeats'] ?? 0,
                              filledSeats: ride['passengers'].length ?? 0,
                              estimatedArrivalTime: formatArrivalTime(
                                  ride['expectedArrivalTime']),
                              id: widget.rideRequestId,
                              carCompany: ride['car']['company'] ?? 'Unknown',
                            );
                          } else {
                            return ListTile(
                              title: Text("Error: Ride data is not valid"),
                            );
                          }
                        } catch (error, stackTrace) {
                          print(
                              "Error building MatchCard from loaded ride: $error");
                          return ListTile(
                            title: Text("Error loading ride"),
                            subtitle: Text("$error"),
                          );
                        }
                      },
                    );
                  } else if (state is RiderRequestError) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else if (state is RiderRequestInitial) {
                    if (widget.initialMatchingRides.isEmpty) {
                      return const Center(child: Text('No rides found.'));
                    }
                    return ListView.builder(
                      itemCount: widget.initialMatchingRides.length,
                      itemBuilder: (context, index) {
                        try {
                          final ride = widget.initialMatchingRides[index];
                          if (ride is Map<String, dynamic>) {
                            return MatchCard(
                              driverName: ride['driverId'] ?? 'Unknown Driver',
                              rating: 4.3,
                              trips: 5,
                              source: ride['source']?['address'] ?? 'Unknown',
                              destination:
                                  ride['destination']?['address'] ?? 'Unknown',
                              fare: ride['fare'] ?? 0,
                              carModel: ride['car']['model'] ?? 'Unknown',
                              totalSeats: ride['numOfSeats'] ?? 0,
                              filledSeats: ride['passengers'].length ?? 0,
                              estimatedArrivalTime: formatArrivalTime(
                                  ride['expectedArrivalTime']),
                              id: widget.rideRequestId,
                              carCompany: ride['car']['company'] ?? 'Unknown',
                            );
                          } else {
                            return ListTile(
                              title: Text("Error: Ride data is not valid"),
                            );
                          }
                        } catch (error, stackTrace) {
                          print(
                              "Error building MatchCard from initial ride: $error");
                          return ListTile(
                            title: Text("Error loading ride"),
                            subtitle: Text("$error"),
                          );
                        }
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
