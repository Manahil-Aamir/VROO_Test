import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vroo_test/core/services/bb.dart';

class LocationTracking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationService = Provider.of<LocationService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("Background Location Tracking")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => locationService.startTracking(),
              child: Text("Start Tracking"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => locationService.stopTracking(),
              child: Text("Stop Tracking"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
