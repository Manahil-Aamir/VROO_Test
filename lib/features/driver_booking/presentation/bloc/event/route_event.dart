abstract class RouteEvent {}

class FetchRoutesEvent extends RouteEvent {
  final String fromPlaceId;
  final String toPlaceId;

  FetchRoutesEvent(this.fromPlaceId, this.toPlaceId);
}

// abstract class RouteMapEvent {}

// class InitializeMapEvent extends RouteMapEvent {
//   final List<dynamic> routeData;

//   InitializeMapEvent(this.routeData);
// }

// class SelectRouteEvent extends RouteMapEvent {
//   final dynamic route;

//   SelectRouteEvent(this.route);
// }

// class SaveRouteEvent extends RouteMapEvent {}
