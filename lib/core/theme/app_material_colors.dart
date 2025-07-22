import 'package:flutter/material.dart';

class AppMaterialColors {
  // Primary Blue Material Color (from web design #1E3A8A)
  static const MaterialColor primaryBlue = MaterialColor(0xFF1E3A8A, {
    50: Color(0xFFE8F2FF),
    100: Color(0xFFC5D9FF),
    200: Color(0xFF9EC0FF),
    300: Color(0xFF77A7FF),
    400: Color(0xFF5A94FF),
    500: Color(0xFF1E3A8A), // Primary
    600: Color(0xFF1A3478),
    700: Color(0xFF162D66),
    800: Color(0xFF122654),
    900: Color(0xFF0E1F42),
  });

  // Secondary Orange Material Color
  static const MaterialColor secondaryOrange = MaterialColor(0xFFFF9800, {
    50: Color(0xFFFFF3E0),
    100: Color(0xFFFFE0B2),
    200: Color(0xFFFFCC80),
    300: Color(0xFFFFB74D),
    400: Color(0xFFFFA726),
    500: Color(0xFFFF9800), // Secondary
    600: Color(0xFFFB8C00),
    700: Color(0xFFF57C00),
    800: Color(0xFFEF6C00),
    900: Color(0xFFE65100),
  });

  // Accent Gold Material Color
  static const MaterialColor accentGold = MaterialColor(0xFFFFD700, {
    50: Color(0xFFFFF8E1),
    100: Color(0xFFFFECB3),
    200: Color(0xFFFFE082),
    300: Color(0xFFFFD54F),
    400: Color(0xFFFFCA28),
    500: Color(0xFFFFD700), // Accent
    600: Color(0xFFFFB300),
    700: Color(0xFFFFA000),
    800: Color(0xFFFF8F00),
    900: Color(0xFFFF6F00),
  });
}
