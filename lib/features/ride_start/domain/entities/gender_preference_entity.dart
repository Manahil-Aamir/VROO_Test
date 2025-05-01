import 'package:equatable/equatable.dart';

class GenderPreferencesEntity extends Equatable {
  final String id;
  final bool maleOnly;
  final bool femaleOnly;

  const GenderPreferencesEntity({
    required this.id,
    required this.maleOnly,
    required this.femaleOnly,
  });

  @override
  List<Object> get props => [id, maleOnly, femaleOnly];
}
