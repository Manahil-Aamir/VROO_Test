import '../../domain/entity/source_and_dest_entity.dart';

class SourceAndDestModel extends SourceAndDestEntity {
  SourceAndDestModel({
    required super.toPlaceId,
    required super.fromPlaceId,
    required super.toDescription,
    required super.fromDescription,
    super.sourceCoordinates,
    super.destCoordinates,
  });

  Map<String, dynamic> toMap() {
    return {
      'toPlaceId': toPlaceId,
      'fromPlaceId': fromPlaceId,
      'toDescription': toDescription,
      'fromDescription': fromDescription,
      'sourceCoordinates': sourceCoordinates,
      'destCoordinates': destCoordinates,
    };
  }

  factory SourceAndDestModel.fromMap(Map<String, dynamic> map) {
    return SourceAndDestModel(
      toPlaceId: map['toPlaceId'],
      fromPlaceId: map['fromPlaceId'],
      toDescription: map['toDescription'],
      fromDescription: map['fromDescription'],
      sourceCoordinates: map['sourceCoordinates'],
      destCoordinates: map['destCoordinates'],
    );
  }
}
