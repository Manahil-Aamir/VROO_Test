import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vroo_test/features/ride_start/data/models/inride_passenger_model.dart';

import '../../../../core/theme/color/color_theme.dart';
import '../../data/models/ridestart_data_model.dart';
import 'static_modal.dart';

class RideTrackingPage extends StatefulWidget {
  final RidestartDataModel rideData;

  const RideTrackingPage({super.key, required this.rideData});

  @override
  State<RideTrackingPage> createState() => _RideTrackingPageState();
}

class _RideTrackingPageState extends State<RideTrackingPage> {
  static const platform = MethodChannel('com.example.vroo_test/ride_map');

  Future<void> _initMap() async {
    try {
      final List<Map<String, double>> routeCoords = widget.rideData.routeCoords
          .map((point) => {'lat': point[0], 'lng': point[1]})
          .toList();

      final List<Map<String, dynamic>> passengers =
          widget.rideData.passengers.map((passenger) {
        final InridePassengerModel p = passenger;
        final bool isSameSource =
            p.rideRequest.matches.any((match) => match.sameSource);

        return {
          'id': p.riderId,
          'name': p.riderName,
          'pickupLat': p.rideRequest.source.coords[0],
          'pickupLng': p.rideRequest.source.coords[1],
          'dropoffLat': p.rideRequest.destination.coords[0],
          'dropoffLng': p.rideRequest.destination.coords[1],
          'sameSource': isSameSource,
        };
      }).toList();

      final Map<String, dynamic> mapData = {
        'routeCoords': routeCoords,
        'passengers': passengers,
        'source': {
          'lat': widget.rideData.source.coords[0],
          'lng': widget.rideData.source.coords[1],
          'address': widget.rideData.source.address,
        },
        'destination': {
          'lat': widget.rideData.destination.coords[0],
          'lng': widget.rideData.destination.coords[1],
          'address': widget.rideData.destination.address,
        },
      };

      await platform.invokeMethod('initializeMap', mapData);
    } on PlatformException catch (e) {
      debugPrint("Failed to initialize map: '${e.message}'");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: AndroidView(
              viewType: 'ride_tracking_map',
              creationParams: {
                'showMarkersByDefault': true,
                'showMarkers': true,
                'showLabels': true,
                'forceShowLabels': true,
                'cameraPosition': {
                  'latitude': 24.9412,
                  'longitude': 67.1139,
                  'zoom': 15.0,
                },
              },
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: (int id) {
                _initMap();
              },
            ),
          ),

          Positioned(
            top: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: ThemeColors.primaryColorDark),
                  onPressed: () {
                    print('Back button pressed');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Bottom sheet overlay
          RideDetailsBottomSheet(
            rideData: widget.rideData,
          ),
        ],
      ),
    );
  }
}
