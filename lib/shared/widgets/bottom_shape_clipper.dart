import 'package:flutter/material.dart';

class BottomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 40); // Reduced from 40 to 30
    path.quadraticBezierTo(size.width / 2, size.height, size.width,
        size.height - 30); // Reduced curve height
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

// class BottomShapeClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(0, 0);
//     path.lineTo(0, size.height - 20); // Adjust this value for a smaller shape
//     path.quadraticBezierTo(
//         size.width / 2, size.height, size.width, size.height - 20);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }
