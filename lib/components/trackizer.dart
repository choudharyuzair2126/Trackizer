import 'package:flutter/material.dart';

class Trackizer extends StatelessWidget {
  final double fontSize;
  final double width;
  const Trackizer({super.key, required this.fontSize, required this.width});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/icon.png'),
        SizedBox(width: width),
        Text(
          "TRACKIZER",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
