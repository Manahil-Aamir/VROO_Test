// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../domain/entity/prediction.dart';

// class LocationLocalDataSource {
//   static const _fromKey = 'saved_from_location';
//   static const _toKey = 'saved_to_location';

//   Future<void> saveLocations(Prediction? from, Prediction? to) async {
//     final prefs = await SharedPreferences.getInstance();
//     if (from != null) {
//       prefs.setString(_fromKey, jsonEncode(from.toMap()));
//     }
//     if (to != null) {
//       prefs.setString(_toKey, jsonEncode(to.toMap()));
//     }
//   }

//   Future<Prediction?> getFromLocation() async {
//     final prefs = await SharedPreferences.getInstance();
//     final data = prefs.getString(_fromKey);
//     return data != null ? Prediction.fromJson(jsonDecode(data)) : null;
//   }

//   Future<Prediction?> getToLocation() async {
//     final prefs = await SharedPreferences.getInstance();
//     final data = prefs.getString(_toKey);
//     return data != null ? Prediction.fromJson(jsonDecode(data)) : null;
//   }

//   Future<void> clearLocations() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_fromKey);
//     await prefs.remove(_toKey);
//   }
// }
