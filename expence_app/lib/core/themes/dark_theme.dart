import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.cyan,
  scaffoldBackgroundColor: const Color(0xFF121212), // خلفية داكنة أكثر
  colorScheme: const ColorScheme.dark(
    primary: Colors.cyan, // اللون الرئيسي
    onPrimary: Colors.white,
    secondary: Color(0xFF03DAC6), // لون ثانوي حديث
    onSecondary: Colors.white,
    surface: Color(0xFF1E1E1E), // لون السطح
    onSurface: Colors.white,
    background: Color(0xFF121212), // خلفية داكنة
  ),
  cardColor: const Color(0xFF1E1E1E), // لون البطاقات
  shadowColor: Colors.black.withOpacity(0.5),
  fontFamily: "cairo",
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E), // لون شريط التطبيق
    elevation: 0,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.cyan, // لون الأزرار
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);