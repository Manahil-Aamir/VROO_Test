// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../bloc/bloc/route_bloc.dart';
// import '../bloc/state/route_state.dart';

// class RouteMapPage extends StatelessWidget {
//   final String fromPlaceId;
//   final String toPlaceId;
//   final String fromPlaceDesc;
//   final String toPlaceDesc;

//   const RouteMapPage({
//     Key? key,
//     required this.fromPlaceId,
//     required this.toPlaceId,
//     required this.fromPlaceDesc,
//     required this.toPlaceDesc,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => RouteBloc()..add(FetchRoutes(fromPlaceId, toPlaceId)),
//       child: Scaffold(
//         appBar: AppBar(title: const Text('Select a Route')),
//         body: BlocBuilder<RouteBloc, RouteState>(
//           builder: (context, state) {
//             if (state is RouteLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is RouteLoaded) {
//               return _RouteMap(
//                 routeData: state.routes,
//                 fromPlaceDesc: fromPlaceDesc,
//                 toPlaceDesc: toPlaceDesc,
//               );
//             } else if (state is RouteError) {
//               return Center(child: Text('Error: ${state.message}'));
//             } else {
//               return const Center(child: Text('No route data available.'));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// class _RouteMap extends StatefulWidget {
//   final List<dynamic> routeData;
//   final String fromPlaceDesc;
//   final String toPlaceDesc;

//   const _RouteMap({
//     Key? key,
//     required this.routeData,
//     required this.fromPlaceDesc,
//     required this.toPlaceDesc,
//   }) : super(key: key);

//   @override
//   _RouteMapState createState() => _RouteMapState();
// }

// class _RouteMapState extends State<_RouteMap> {
//   late GoogleMapController _mapController;
//   final Set<Polyline> _polylines = {};
//   final Set<Marker> _markers = {};
//   dynamic _selectedRoute;

//   @override
//   void initState() {
//     super.initState();
//     _createPolylinesAndMarkers();
//   }

//   void _createPolylinesAndMarkers() {
//     for (var route in widget.routeData) {
//       final routeCoords = (route['coords'] as List<dynamic>)
//           .map((coord) => LatLng(coord[0], coord[1]))
//           .toList();

//       final polyline = Polyline(
//         polylineId: PolylineId(route['id'].toString()),
//         color: Colors.grey,
//         width: 5,
//         points: routeCoords,
//         consumeTapEvents: true,
//         onTap: () => _onRouteSelected(route),
//       );

//       _polylines.add(polyline);

//       if (routeCoords.isNotEmpty) {
//         _markers.add(Marker(
//           markerId: MarkerId('start-${route['id']}'),
//           position: routeCoords.first,
//           infoWindow: InfoWindow(title: 'Start of Route ${route['id']}'),
//         ));
//         _markers.add(Marker(
//           markerId: MarkerId('end-${route['id']}'),
//           position: routeCoords.last,
//           infoWindow: InfoWindow(title: 'End of Route ${route['id']}'),
//         ));
//       }
//     }
//   }

//   void _onRouteSelected(dynamic route) {
//     setState(() {
//       _selectedRoute = route;

//       _polylines.clear();
//       _polylines.addAll(widget.routeData.map((r) {
//         final routeCoords = (r['coords'] as List<dynamic>)
//             .map((coord) => LatLng(coord[0], coord[1]))
//             .toList();

//         return Polyline(
//           polylineId: PolylineId(r['id'].toString()),
//           color: r['id'] == route['id'] ? Colors.blue : Colors.grey,
//           width: r['id'] == route['id'] ? 8 : 5,
//           points: routeCoords,
//         );
//       }));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: LatLng(
//               widget.routeData[0]['coords'][0][0],
//               widget.routeData[0]['coords'][0][1],
//             ),
//             zoom: 12,
//           ),
//           polylines: _polylines,
//           markers: _markers,
//           onMapCreated: (controller) => _mapController = controller,
//         ),
//         if (_selectedRoute != null)
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: () {
//                 // Logic to handle route selection
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Selected route: ${_selectedRoute['id']}')),
//                 );
//               },
//               child: const Text('Select Route'),
//             ),
//           ),
//       ],
//     );
//   }
// }
