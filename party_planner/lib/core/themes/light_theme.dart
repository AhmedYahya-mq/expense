import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.cyan,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Colors.cyan, // اللون الرئيسي
    secondary: Color(0xFF03DAC6), // لون ثانوي حديث
    surface: Color(0xFFF5F5F5), // لون السطح
    background: Colors.white, // خلفية بيضاء
  ),
  cardColor: const Color.fromARGB(255, 240, 240, 240), // لون البطاقات
  shadowColor: Colors.grey.withOpacity(0.3),
  fontFamily: "cairo",
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white, // لون شريط التطبيق
    elevation: 0,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.cyan, // لون الأزرار
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);