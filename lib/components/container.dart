import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final String image;
  const ImageContainer({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
