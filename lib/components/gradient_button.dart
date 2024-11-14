import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback ontap;
  final String text;
  const GradientButton({super.key, required this.ontap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: const Border(
              left: BorderSide(
                  color: Color.fromARGB(255, 255, 167, 155), width: 2),
              right: BorderSide(
                  color: Color.fromARGB(255, 255, 167, 155), width: 2),
              top: BorderSide(
                  color: Color.fromARGB(255, 255, 167, 155), width: 2),
              bottom: BorderSide.none),
          boxShadow: const [
            BoxShadow(
                color: Color(0xFFFF7966),
                spreadRadius: .1,
                blurRadius: 12,
                offset: Offset(0, 2)),
          ]),
      child: SizedBox(
        height: 45,
        width: MediaQuery.of(context).size.width - 50,
        child: ElevatedButton(
          onPressed: ontap,
          style: const ButtonStyle(
            elevation: WidgetStatePropertyAll(5.0),
            backgroundColor: WidgetStatePropertyAll(
              Color(0xFFFF7966),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
