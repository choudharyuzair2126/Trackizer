import 'package:flutter/material.dart';
import 'package:trackizer/theme/color.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final bool isObsecure;
  final TextInputType textInputType;
  final String? hintText;
  final String? labelText;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.isObsecure,
    required this.textInputType,
    this.hintText,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObsecure,
      keyboardType: textInputType,
      decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colour.greyBorder,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colour.greyBorder,
            ),
            borderRadius: BorderRadius.circular(20),
          )),
    );
  }
}
