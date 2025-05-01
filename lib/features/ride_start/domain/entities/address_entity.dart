import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String address;
  final String placeId;
  final List<double> coords;
  final String cellId;
  final String? id;

  const Address({
    required this.address,
    required this.placeId,
    required this.coords,
    required this.cellId,
    this.id,
  });

  @override
  List<Object> get props => [address, placeId, coords, cellId, id ?? ''];
}
