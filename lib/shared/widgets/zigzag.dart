import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZigZagIconWidget extends StatelessWidget {
  const ZigZagIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(140.w, 140.h), // Canvas size
      painter: ZigZagPainter(),
      child: Container(
        width: 120.w,
        height: 120.h,
        alignment: Alignment.center,
        child: Icon(
          Icons.check, // Checkmark Icon
          size: 75.sp, // Icon size
          weight: 800, // Bolder weight
          color: Theme.of(context).iconTheme.color, // Use theme color
        ),
      ),
    );
  }
}

class ZigZagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFEC8825) // Orange color
      ..style = PaintingStyle.fill;

    final Path path = Path();
    final double zigZagHeight = 10.0.h; // Height of the zigzag
    final double radius = size.width / 2.0; // Radius of the circle
    final int points = 24; // Number of points for the zigzag pattern

    for (int i = 0; i <= points; i++) {
      double angle = i * (2 * pi / points);
      double x = size.width / 2 +
          (radius + (i % 2 == 0 ? -zigZagHeight : zigZagHeight)) * cos(angle);
      double y = size.height / 2 +
          (radius + (i % 2 == 0 ? -zigZagHeight : zigZagHeight)) * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // Use quadratic Bezier curves to create a smoother, wavy pattern
        double prevAngle = (i - 1) * (2 * pi / points);
        double prevX = size.width / 2 +
            (radius + ((i - 1) % 2 == 0 ? -zigZagHeight : zigZagHeight)) *
                cos(prevAngle);
        double prevY = size.height / 2 +
            (radius + ((i - 1) % 2 == 0 ? -zigZagHeight : zigZagHeight)) *
                sin(prevAngle);
        double controlX = (prevX + x) / 2;
        double controlY = (prevY + y) / 2;
        path.quadraticBezierTo(controlX, controlY, x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
