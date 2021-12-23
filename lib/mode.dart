import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: Colors.blueGrey,
    appBarTheme: const AppBarTheme(
      color: Colors.blueGrey,
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(color: Colors.red),
    scaffoldBackgroundColor: const Color(0xFF15202B),
  );
}
