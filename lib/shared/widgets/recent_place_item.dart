import 'package:flutter/material.dart';

class RecentPlaceItem extends StatelessWidget {
  final String title;
  final String address;
  final String distance;

  const RecentPlaceItem({
    required this.title,
    required this.address,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.place, color: Colors.orange),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(address),
      trailing: Text(distance, style: TextStyle(color: Colors.grey)),
    );
  }
}
