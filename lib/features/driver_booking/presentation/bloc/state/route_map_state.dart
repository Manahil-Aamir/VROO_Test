import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

// class MapLoaded extends MapState {
//   final Set<Polyline> polylines;
//   final Set<Marker> markers;
//   final dynamic selectedRoute;

//   MapLoaded({
//     required this.polylines,
//     required this.markers,
//     this.selectedRoute,
//   });
// }

class MapLoaded extends MapState {
  final List<dynamic> routeData;
  final Map<String, dynamic>? selectedRoute;

  MapLoaded({required this.routeData, this.selectedRoute});

  @override
  List<Object?> get props => [routeData, selectedRoute];
}

class MapError extends MapState {
  final String message;

  MapError(this.message);
}
