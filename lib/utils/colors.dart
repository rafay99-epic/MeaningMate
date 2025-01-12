import 'package:flutter/material.dart';

ThemeData basecolors = ThemeData(
  useMaterial3: true, // Enable Material 3
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF6C63FF),
    secondary: Color(0xFF2196F3),
    surface: Color(0xFFF5F5F5),
    error: Color(0xFFF44336),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    onSurface: Color(0xFF000000),
    onError: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  ),
  fontFamily: 'Roboto',
);
