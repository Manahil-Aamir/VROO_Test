import 'package:equatable/equatable.dart';

class OthersEntity extends Equatable {
  final String riderId;
  final String name;

  const OthersEntity({
    required this.riderId,
    required this.name,
  });

  @override
  List<Object> get props => [riderId];
}
