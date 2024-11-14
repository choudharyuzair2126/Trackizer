import 'package:flutter/material.dart';
import 'package:trackizer/theme/color.dart';

class Box extends StatelessWidget {
  //final double width;
  final String text1;
  final String text2;
  final Color borderColor;
  const Box({
    super.key,
    //   required this.width,
    required this.text1,
    required this.text2,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      width: MediaQuery.of(context).size.width / 3.3,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colour.boxColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 2,
                color: Colour.boxBorder,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text1,
                    style: TextStyle(
                      color: Colour.textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(text2,
                      style: TextStyle(
                        color: Colour.whiteButton,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2,
                width: MediaQuery.of(context).size.width / 3.3 - 55,
                decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
