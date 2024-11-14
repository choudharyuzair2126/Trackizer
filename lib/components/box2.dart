import 'package:flutter/material.dart';
import 'package:trackizer/theme/color.dart';

class Box2 extends StatelessWidget {
  //final double width;
  final String text1;
  final String text2;
  final Color borderColor;
  final IconData icon;
  final String total;
  final double value;
  final String spend;
  const Box2({
    super.key,
    //   required this.width,
    required this.text1,
    required this.text2,
    required this.borderColor,
    required this.icon,
    required this.total,
    required this.spend,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 87,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            //   height: 100,
            //     width: 14,
            decoration: BoxDecoration(
              color: Colour.boxColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 2,
                color: Colour.boxBorder,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        icon,
                        size: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            text1,
                            style: TextStyle(
                              color: Colour.whiteButton,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(text2,
                              style: TextStyle(
                                color: Colour.grey30,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            spend,
                            style: TextStyle(
                              color: Colour.whiteButton,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(total,
                              style: TextStyle(
                                color: Colour.grey30,
                                fontSize: 13,
                                //   fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 14, top: 70),
            child: LinearProgressIndicator(
              value: value,
              color: borderColor,
              backgroundColor: Colour.linear1,
            ),
          )
        ],
      ),
    );
  }
}
