import 'package:flutter/material.dart';

class BottomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start from top-left
    path.moveTo(0, 0);
    // Line to bottom-left (leaving space for curve)
    path.lineTo(0, size.height - 25);

    // Perfect symmetric curve using quadratic bezier
    // Control point is exactly at center horizontally and at bottom vertically
    path.quadraticBezierTo(
        size.width / 2, // Control point X (center)
        size.height, // Control point Y (bottom)
        size.width, // End point X (right edge)
        size.height - 25 // End point Y (same height as start)
        );

    // Line to top-right
    path.lineTo(size.width, 0);
    // Close the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
