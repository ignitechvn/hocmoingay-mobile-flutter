import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1E3A8A); // Blue (from web design)
  static const Color primaryLight = Color(0xFF3B5998);
  static const Color primaryDark = Color(0xFF1E3A8A);

  // Secondary Colors
  static const Color secondary = Color(0xFFFF9800); // Orange
  static const Color secondaryLight = Color(0xFFFFB74D);
  static const Color secondaryDark = Color(0xFFF57C00);

  // Accent Colors
  static const Color accent = Color(0xFFFFD700); // Gold
  static const Color accentLight = Color(0xFFFFE082);
  static const Color accentDark = Color(0xFFFFB300);

  // Background Colors
  static const Color background = Color(0xFFF8FAFC); // Light blue background
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textInverse = Colors.white;
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);

  // Role-specific Colors
  static const Color teacherPrimary = Color(
    0xFF1E3A8A,
  ); // Blue (from web design)
  static const Color teacherLight = Color(0xFFE8F2FF);
  static const Color studentPrimary = Color(0xFFFF9800); // Orange
  static const Color studentLight = Color(0xFFFFF3E0);
  static const Color parentPrimary = Color(0xFF9C27B0); // Purple
  static const Color parentLight = Color(0xFFF3E5F5);

  // Neutral Colors
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Decorative Colors
  static const Color decorativePurple = Color(0xFFE6E6FA);
  static const Color decorativeBlue = Color(
    0xFFE8F2FF,
  ); // Updated to match new primary
  static const Color decorativeGreen = Color(0xFFE8F5E8);
  static const Color decorativeYellow = Color(0xFFFFF8E1);
  static const Color decorativeOrange = Color(0xFFFFF3E0);
  static const Color decorativePink = Color(0xFFFCE4EC);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Role Gradients
  static const LinearGradient teacherGradient = LinearGradient(
    colors: [teacherPrimary, teacherLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient studentGradient = LinearGradient(
    colors: [studentPrimary, studentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
