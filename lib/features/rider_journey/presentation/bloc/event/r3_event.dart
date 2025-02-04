abstract class R3Event {}

class SendRideRequestEvent extends R3Event {
  final Map<String, dynamic> rideData;
  SendRideRequestEvent(this.rideData);
}

class GetCoordinatesEvent extends R3Event {
  final String placeId;
  final bool
      isSource; // Indicates if the coordinates are for the source or destination.
  GetCoordinatesEvent({required this.placeId, this.isSource = true});
}
