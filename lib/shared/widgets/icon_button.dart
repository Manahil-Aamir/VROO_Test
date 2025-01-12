import 'package:flutter/material.dart';
import '../../core/theme/color/color_theme.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CustomIconButton({Key? key, required this.icon, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark, // Use card color from theme
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: IconButton(
        icon: Icon(icon, color: ThemeColors.iconColor), // Use theme icon color
        onPressed: onPressed,
      ),
    );
  }
}


// class CustomIconButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onPressed;

//   const CustomIconButton({
//     Key? key,
//     required this.icon,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF434143),
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: IconButton(
//         icon: Icon(icon, color: Colors.white),
//         onPressed: onPressed,
//       ),
//     );
//   }
// }
