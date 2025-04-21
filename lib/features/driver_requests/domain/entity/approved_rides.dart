import 'ratings.dart';
import 'time_range.dart';

class ApprovedRidesEntity {
  final String riderId;
  final String riderName;
  final String phoneNumber;      
  final String status;
  final int fare;
  final String rideRequestId;
  final String source;          
  final String destination;     
  final DateTime date;
  final TimeRange pickupTimeRange;
  final DateTime maxArrivalTime;
  final Ratings ratings; 
  final String fcmToken;

  ApprovedRidesEntity({
    required this.riderId,
    required this.riderName,
    required this.phoneNumber,
    required this.status,
    required this.fare,
    required this.rideRequestId,
    required this.source,
    required this.destination,
    required this.date,
    required this.pickupTimeRange,
    required this.maxArrivalTime,
    required this.ratings,
    required this.fcmToken,
  });
}
