abstract class RouteEvent {}

class FetchRoutesEvent extends RouteEvent {
  final String fromPlaceId;
  final String toPlaceId;

  FetchRoutesEvent(this.fromPlaceId, this.toPlaceId);
}
