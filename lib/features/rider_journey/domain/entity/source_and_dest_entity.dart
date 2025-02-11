import 'package:google_maps_flutter/google_maps_flutter.dart';

class SourceAndDestEntity {
  final String toPlaceId;
  final String fromPlaceId;
  final String toDescription;
  final String fromDescription;
  LatLng? sourceCoordinates;
  LatLng? destCoordinates;

  SourceAndDestEntity({
    required this.toPlaceId,
    required this.fromPlaceId,
    required this.toDescription,
    required this.fromDescription,
    this.sourceCoordinates,
    this.destCoordinates,
  });
}
