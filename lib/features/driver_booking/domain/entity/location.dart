class Location {
  final String start; // Starting location description
  final String destination; // Destination location description
  final String startPlaceId; // Starting location place ID
  final String destinationPlaceId; // Destination location place ID

  Location({
    required this.start,
    required this.destination,
    required this.startPlaceId,
    required this.destinationPlaceId,
  });

  // Convert the object to a Map for serialization
  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'destination': destination,
      'startPlaceId': startPlaceId,
      'destinationPlaceId': destinationPlaceId,
    };
  }

  // Create an object from a Map (deserialization)
  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      start: map['start'],
      destination: map['destination'],
      startPlaceId: map['startPlaceId'],
      destinationPlaceId: map['destinationPlaceId'],
    );
  }

  // Optional: Override toString() for easy debugging
  @override
  String toString() {
    return 'Location(start: $start, destination: $destination)';
  }
}