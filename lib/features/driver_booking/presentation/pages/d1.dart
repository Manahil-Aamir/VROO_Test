import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class D1Screen extends StatelessWidget {
  final String toPlaceID;
  final String fromPlaceID;
  final String toDescription;
  final String fromDescription;
  final List<dynamic> selectedRouteCoords;

  D1Screen({
    super.key,
    required this.toPlaceID,
    required this.fromPlaceID,
    required this.toDescription,
    required this.fromDescription,
    required this.selectedRouteCoords,
  })  : sourceCoord = LatLng(selectedRouteCoords.first[0], selectedRouteCoords.first[1]),
        destinationCoord = LatLng(selectedRouteCoords.last[0], selectedRouteCoords.last[1]);

  final LatLng sourceCoord;
  final LatLng destinationCoord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('D1 Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To Place ID: $toPlaceID',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'From Place ID: $fromPlaceID',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'To Description: $toDescription',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'From Description: $fromDescription',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Source Coordinate: $sourceCoord',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Destination Coordinate: $destinationCoord',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
