// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class DarkButton extends StatelessWidget {
  final VoidCallback ontap;
  final String text;
  final Color buttonColor;
  final Color borderColor;
  final textColor;
  final double size;
  //final width;
  final icon;
  const DarkButton({
    super.key,
    required this.ontap,
    required this.text,
    required this.buttonColor,
    required this.borderColor,
    this.textColor,
    this.icon,
    required this.size,
//this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: SizedBox(
        height: 45,
        width: MediaQuery.of(context).size.width - 50,
        child: ElevatedButton(
          onPressed: ontap,
          style: ButtonStyle(
            elevation: const WidgetStatePropertyAll(5.0),
            backgroundColor: WidgetStatePropertyAll(buttonColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: icon,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: size,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
