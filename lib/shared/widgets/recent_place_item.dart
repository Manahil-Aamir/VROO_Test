import 'package:flutter/material.dart';
import '../../core/theme/color/color_theme.dart';

class RecentPlaceItem extends StatelessWidget {
  final String title;
  final String address;
  final String distance;

  const RecentPlaceItem({
    super.key,
    required this.title,
    required this.address,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.place,
          color: Theme.of(context).primaryColor), // Use primary color
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(address, style: Theme.of(context).textTheme.bodyMedium),
      trailing: Text(
        distance,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: ThemeColors.bodyTextColor),
      ),
    );
  }
}

// class RecentPlaceItem extends StatelessWidget {
//   final String title;
//   final String address;
//   final String distance;

//   const RecentPlaceItem({
//     required this.title,
//     required this.address,
//     required this.distance,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(Icons.place, color: Colors.orange),
//       title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//       subtitle: Text(address),
//       trailing: Text(distance, style: TextStyle(color: Colors.grey)),
//     );
//   }
// }
