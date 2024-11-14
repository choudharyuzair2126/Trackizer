import 'package:flutter/material.dart';

class Navigation {
  static push(context, route) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));
  }

  static pop(context) {
    Navigator.pop(context);
  }

  static replace(context, route) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => route));
  }
}
