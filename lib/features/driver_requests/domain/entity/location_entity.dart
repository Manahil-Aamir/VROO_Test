class LocationEntity {
  final String address;
  final String cellId;
  final List<double> coords;
  final String placeId;

  LocationEntity({
    required this.address,
    required this.cellId,
    required this.coords,
    required this.placeId,
  });
}
