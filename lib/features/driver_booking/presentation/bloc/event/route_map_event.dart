abstract class MapEvent {}

class LoadRoutesEvent extends MapEvent {
  final List<dynamic> routeData;

  LoadRoutesEvent(this.routeData);
}

class SelectRouteEvent extends MapEvent {
  final dynamic selectedRoute;

  SelectRouteEvent(this.selectedRoute);
}
