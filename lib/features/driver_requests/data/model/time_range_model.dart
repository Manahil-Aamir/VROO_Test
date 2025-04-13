import '../../domain/entity/time_range.dart';

class TimeRangeModel {
  final DateTime min;
  final DateTime max;

  TimeRangeModel({
    required this.min,
    required this.max,
  });

  factory TimeRangeModel.fromJson(Map<String, dynamic> json) {
    return TimeRangeModel(
      min: DateTime.parse(json['min']),
      max: DateTime.parse(json['max']),
    );
  }

  TimeRange toEntity() => TimeRange(
        min: min,
        max: max,
      );
}