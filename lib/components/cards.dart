// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:trackizer/theme/color.dart';

class Cards extends StatelessWidget {
  final cards;
  const Cards({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    String cardNumber = cards['Card Number'];
    String maskedNumber =
        '${cardNumber.substring(0, 4)} XXXX XXXX ${cardNumber.substring(cardNumber.length - 4)}';
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        border: Border.all(color: Colour.greyBorder),
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
            image: AssetImage(
              "assets/images/Main.png",
            ),
            fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          Image.asset("assets/images/mcard.png"),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Master Card",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 80,
          ),
          Text(
            cards['Name'],
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            maskedNumber,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            cards['Valid Till'],
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}
