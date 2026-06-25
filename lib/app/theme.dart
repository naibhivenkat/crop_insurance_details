import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,

      colorSchemeSeed: Colors.green,

      scaffoldBackgroundColor:
          const Color(0xffF6F8FB),

      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),

      inputDecorationTheme:
          const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}