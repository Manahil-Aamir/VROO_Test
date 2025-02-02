import 'dart:math';
import 'package:flutter/material.dart';

class BookingConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom Zig-Zag Circle with Icon
            CustomPaint(
              size: const Size(120, 120), // Canvas size
              painter: ZigZagPainter(),
              child: Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                child: Icon(
                  Icons.check, // Checkmark Icon
                  size: 50,
                  color: Color(0xFF2A282A), // Dark gray
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Booking Confirmed Text
            Text(
              "Booking Confirmed",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A282A), // Dark gray
              ),
            ),
            const SizedBox(height: 30),
            // Proceed to Home Screen Button
            ElevatedButton(
              onPressed: () {
                // Add navigation logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2A282A), // Dark gray background
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Proceed to Home Screen",
                style: TextStyle(
                  color: Colors.white, // White text
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ZigZagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xFFEC8825) // Orange color
      ..style = PaintingStyle.fill;

    final Path path = Path();
    final double zigZagHeight = 10.0; // Height difference for zigzag
    final double radius = size.width / 2.0; // Radius of the overall shape
    final int points = 24; // Number of points (increase for smoother zigzag)
    final double cornerRadius = 5.0; // Radius for rounded corners

    for (int i = 0; i <= points; i++) {
      double angle = i * (2 * pi / points); // Angle for the current point
      double nextAngle = (i + 1) * (2 * pi / points); // Angle for the next point

      // Alternate between inner and outer radius
      double currentRadius = radius + (i % 2 == 0 ? -zigZagHeight : zigZagHeight);
      double nextRadius = radius + ((i + 1) % 2 == 0 ? -zigZagHeight : zigZagHeight);

      // Current point
      double x = size.width / 2 + currentRadius * cos(angle);
      double y = size.height / 2 + currentRadius * sin(angle);

      // Next point
      double nextX = size.width / 2 + nextRadius * cos(nextAngle);
      double nextY = size.height / 2 + nextRadius * sin(nextAngle);

      if (i == 0) {
        path.moveTo(x, y); // Start the path
      } else {
        // Create rounded corners between points using arcToPoint
        path.arcToPoint(
          Offset(nextX, nextY),
          radius: Radius.circular(cornerRadius),
          clockwise: true,
        );
      }
    }

    path.close(); // Close the path to complete the shape
    canvas.drawPath(path, paint); // Draw the shape
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

