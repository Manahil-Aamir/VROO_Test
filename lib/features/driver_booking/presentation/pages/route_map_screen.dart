import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../bloc/bloc/route_map_bloc.dart';
import '../bloc/event/route_map_event.dart';
import '../bloc/state/route_map_state.dart';

class RouteMapScreen extends StatelessWidget {
  final List<dynamic> routeData;
  final String fromPlaceDesc;
  final String toPlaceDesc;
  final String fromPlaceId;
  final String toPlaceId;

  const RouteMapScreen({
    Key? key,
    required this.routeData,
    required this.fromPlaceDesc,
    required this.toPlaceDesc,
    required this.fromPlaceId,
    required this.toPlaceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc()..add(LoadRoutesEvent(routeData)),
      child: Scaffold(
        body: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is MapInitial || state is MapLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MapLoaded) {
              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        routeData[0]['coords'][0][0],
                        routeData[0]['coords'][0][1],
                      ),
                      zoom: 12,
                    ),
                    polylines: state.polylines,
                    markers: state.markers,
                  ),
                  if (state.selectedRoute != null) 
                    Stack(
                      children: [
                        Positioned(
                          bottom: 80,
                          left: 20,
                          right: 100,
                          child: Card(
                            color: Theme.of(context).canvasColor,
//                            color: Theme.of(context).primaryColorDark,
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Text(
                                'Distance: ${state.selectedRoute['distance']}\n'
                                'Duration: ${state.selectedRoute['duration']}',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).primaryColorDark),
                                //style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).scaffoldBackgroundColor),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 100,
                          child: GradientButton(
                            onTap: () {
                              // Get the selected route coordinates
                              final selectedRouteCoords = state.selectedRoute['coords'];

                              // Navigate to the D1 screen with the required arguments and the singleton bloc
                              Navigator.pushNamed(
                                context,
                                Routes.d1,
                                arguments: {
                                  'toPlaceID': toPlaceId,
                                  'fromPlaceID': fromPlaceId,
                                  'toDescription': toPlaceDesc,
                                  'fromDescription': fromPlaceDesc,
                                  'selectedRouteCoords': selectedRouteCoords,
                                  'distance': state.selectedRoute['distance'], 
                                  'duration': state.selectedRoute['duration'], 
                                },
                              );
                            },
                            text: 'Select Route',
                          ),
                        ),
                      ],
                    )

                ],
              );
            } else if (state is MapError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
