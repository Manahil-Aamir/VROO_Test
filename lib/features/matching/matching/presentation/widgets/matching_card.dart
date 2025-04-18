import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/bloc/matching_bloc.dart';
import '../bloc/event/matching_event.dart';
import 'car_details.dart';
import 'driver_and_fare.dart';
import 'source_and_destination.dart';

class MatchCard extends StatelessWidget {
  final String driverName;
  final double rating;
  final int trips;
  final String source;
  final String destination;
  final double fare;
  final String carModel;
  final int totalSeats;
  final int filledSeats;
  final String estimatedArrivalTime;
  final String id;
  final String carCompany;
  final String rideId;

  const MatchCard({
    super.key,
    required this.driverName,
    required this.rating,
    required this.trips,
    required this.source,
    required this.destination,
    required this.fare,
    required this.carModel,
    required this.totalSeats,
    required this.filledSeats,
    required this.estimatedArrivalTime,
    required this.id,
    required this.carCompany,
    required this.rideId,
  });

  @override
  Widget build(BuildContext context) {
    print('estimatedArrivalTime: $estimatedArrivalTime');

    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser!;

    return SizedBox(
      width: 363.w,
      height: 200.h,
      child: Card(
        color: theme.primaryColorDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 5.h,
        shadowColor: theme.primaryColorLight,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🚗 Driver Info & Fare
              DriverAndFare(
                  driverName: driverName,
                  rating: rating,
                  trips: trips,
                  fare: fare,
                  estimatedArrivalTime: estimatedArrivalTime),
              SizedBox(height: 12.h),
              // 📍 Source & Destination
              SourceAndDestinationWidget(
                source: source,
                destination: destination,
              ),

              // 🚘 Car Model, Seats & Join Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarDetails(
                    carModel: carModel,
                    totalSeats: totalSeats,
                    filledSeats: filledSeats,
                    estimatedArrivalTime: estimatedArrivalTime,
                    carCompany: carCompany,
                  )
                ],
              ),

              // 🟠 Join Button
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 125.w,
                  height: 34.h,
                  child: ElevatedButton(
                    onPressed: () {
                      final joinData = {
                        "rideId": rideId,
                        "rideRequestId": id,
                        "driverId": driverName,
                        "riderId": user.uid,
                        // "riderId": "new2"
                      };
                      context
                          .read<MatchingBloc>()
                          .add(JoinRideRequestEvent(joinData: joinData));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.primaryColor,
                            theme.primaryColor.withOpacity(0.8)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Join',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
