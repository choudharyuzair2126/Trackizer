import 'package:flutter/material.dart';

class MyTheme {
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF1C1C23),
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
    ),
  );
}
