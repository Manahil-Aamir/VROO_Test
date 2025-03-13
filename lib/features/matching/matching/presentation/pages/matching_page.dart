import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vroo_test/features/matching/matching/presentation/widgets/time_window.dart';
import 'package:vroo_test/features/rider_journey/data/model/matching_rides_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/schedule_model.dart';
import '../../../../../core/router/navigation.dart';
import '../../../../../shared/widgets/appbar.dart';
import '../bloc/bloc/matching_bloc.dart';
import '../bloc/state/matching_state.dart';
import '../widgets/matching_card.dart';

class MatchingPage extends StatefulWidget {
  final String rideRequestId;
  final List<MatchingRideModel> initialMatchingRides;
  final TimeOfDay minPickupTime;
  final TimeOfDay maxPickupTime;
  final ScheduleModel schedule;

  const MatchingPage({
    super.key,
    required this.rideRequestId,
    required this.initialMatchingRides,
    required this.minPickupTime,
    required this.maxPickupTime,
    required this.schedule,
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

  /// Parses and formats an arrival time string.
  String formatArrivalTime(String? arrivalTime) {
    if (arrivalTime == null) return 'Unknown';
    try {
      // Define the input format to match the ISO 8601 format
      DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

      // Parse the input string as a UTC datetime
      DateTime parsedDate = inputFormat.parse(arrivalTime, true).toUtc();

      // Convert UTC time to local time and format it
      return DateFormat.jm().format(parsedDate.toLocal());
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

    return Scaffold(
      appBar: appBar(
        heading: 'Matching Rides',
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0.sp),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: TimeWindowWidget(
                    minPickupTime: widget.minPickupTime,
                    maxPickupTime: widget.maxPickupTime,
                    rideRequestId: widget.rideRequestId,
                    scheduleDate: widget.schedule.date)),
            Expanded(
              child: BlocListener<MatchingBloc, MatchingState>(
                listener: (context, state) {
                  if (state is RiderJoinSuccess) {
                    // Show a success SnackBar when the join is successful.
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Request Sent Successfully'),
                          backgroundColor: theme.secondaryHeaderColor,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    });
                    context.read<Navigation>().navigateTo('/home');
                  } else if (state is RiderRequestError) {
                    // Show an error SnackBar when there's an error.
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${state.error}'),
                          backgroundColor: theme.indicatorColor,
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
                      return ListView.builder(
                        itemCount: state.matchingRides.length,
                        itemBuilder: (context, index) {
                          try {
                            final ride = state.matchingRides[index];
                            return MatchCard(
                              driverName: ride.driverId,
                              rating: 4.3,
                              trips: 5,
                              source: ride.source.address,
                              destination: ride.destination.address,
                              fare: ride.fare,
                              carModel: ride.car.model,
                              totalSeats: ride.numOfSeats.toInt(),
                              filledSeats: ride.passengers.length,
                              estimatedArrivalTime:
                                  formatArrivalTime(ride.expectedArrivalTime),
                              id: widget.rideRequestId,
                              carCompany: ride.car.company,
                              rideId: ride.id,
                            );
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
                            return MatchCard(
                              driverName: ride.driverId,
                              rating: 4.3,
                              trips: 5,
                              source: ride.source.address,
                              destination: ride.destination.address,
                              fare: ride.fare,
                              carModel: ride.car.model,
                              totalSeats: ride.numOfSeats.toInt(),
                              filledSeats: ride.passengers.length,
                              estimatedArrivalTime:
                                  formatArrivalTime(ride.expectedArrivalTime),
                              id: widget.rideRequestId,
                              carCompany: ride.car.company,
                              rideId: ride.id,
                            );
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
      ),
    );
  }
}
