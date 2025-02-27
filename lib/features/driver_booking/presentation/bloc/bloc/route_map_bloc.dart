import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../event/route_map_event.dart';
import '../state/route_map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    // on<LoadRoutesEvent>((event, emit) {
    //   try {
    //     // final polylines = <Polyline>{};
    //     final markers = <Marker>{};
    //     final polylineMap = <String, Polyline>{};

    //     for (var route in event.routeData) {
    //       final List<LatLng> routeCoords = (route['coords'] as List<dynamic>)
    //           .map((coord) => LatLng(coord[0], coord[1]))
    //           .toList();

    //       final polyline = Polyline(
    //         polylineId: PolylineId(route['id'].toString()),
    //         color: Colors.grey,
    //         width: 5,
    //         points: routeCoords,
    //         consumeTapEvents: true, // Enable tap events
    //         onTap: () {
    //           add(SelectRouteEvent(route)); // Dispatch the SelectRouteEvent
    //         },
    //       );

    //       polylineMap[route['id'].toString()] = polyline;

    //       if (routeCoords.isNotEmpty) {
    //         markers.add(Marker(
    //           markerId: MarkerId('start-${route['id']}'),
    //           position: routeCoords.first,
    //           infoWindow: InfoWindow(title: "Start of Route ${route['id']}"),
    //         ));
    //         markers.add(Marker(
    //           markerId: MarkerId('end-${route['id']}'),
    //           position: routeCoords.last,
    //           infoWindow: InfoWindow(title: "End of Route ${route['id']}"),
    //         ));
    //       }
    //     }

    //     emit(MapLoaded(polylines: polylineMap.values.toSet(), markers: markers));
    //   } catch (e) {
    //     emit(MapError(e.toString()));
    //   }
    // });

    on<LoadRoutesEvent>((event, emit) {
      print("Loading routes: ${event.routeData}"); // Debugging
      emit(MapLoaded(routeData: event.routeData, selectedRoute: null));
    });

    // on<SelectRouteEvent>((event, emit) {
    //   if (state is MapLoaded) {
    //     final currentState = state as MapLoaded;
    //     final updatedPolylines = currentState.polylines.map((polyline) {
    //       final isSelected = polyline.polylineId.value == event.selectedRoute['id'].toString();
    //       return polyline.copyWith(
    //         colorParam: isSelected ? Colors.blue : Colors.grey,
    //         widthParam: isSelected ? 10 : 5,
    //       );
    //     }).toSet();

    //     emit(MapLoaded(
    //       polylines: updatedPolylines,
    //       markers: currentState.markers,
    //       selectedRoute: event.selectedRoute,
    //     ));
    //   }
    // });
    on<SelectRouteEvent>((event, emit) {
      print("Bloc received selected route: ${event.selectedRoute}");
      emit(MapLoaded(
          routeData: (state as MapLoaded).routeData,
          selectedRoute: event.selectedRoute));
    });
  }
}
