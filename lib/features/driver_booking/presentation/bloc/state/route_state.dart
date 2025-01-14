abstract class RouteState {}

class RouteInitial extends RouteState {}

class RouteLoading extends RouteState {}

class RouteLoaded extends RouteState {
  final Map<String, dynamic> routeData;

  RouteLoaded(this.routeData);
}

class RouteError extends RouteState {
  final String message;

  RouteError(this.message);
}
