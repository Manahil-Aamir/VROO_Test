import 'package:vroo_test/features/driver_requests/data/model/pending_rides_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/ride_journey_model.dart';

abstract class R3Event {}

class SendRideRequestEvent extends R3Event {
  final RiderJourneyModel rideData;
  SendRideRequestEvent(this.rideData);
}

class GetCoordinatesEvent extends R3Event {
  final String placeId;
  final bool
      isSource; // Indicates if the coordinates are for the source or destination.
  GetCoordinatesEvent({required this.placeId, this.isSource = true});
}
