class ChatUserModel {
  final String id;
  final String name;
  final String fcmToken;
  final String source;
  final String destination;

  ChatUserModel({
    required this.id,
    required this.name,
    required this.fcmToken,
    required this.source,
    required this.destination,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json.containsKey('riderId') ? json['riderId'] : json['driverId'],
      name: json['name'],
      fcmToken: json['fcmToken'],
      source: json['source'],
      destination: json['destination'],
    );
  }
}
