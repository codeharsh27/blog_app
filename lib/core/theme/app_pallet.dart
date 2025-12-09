import 'package:flutter/material.dart';

class AppPallete {
  static const Color backgroundColor = Color(0xFF0A0E21);
  static const Color surfaceColor = Color(0xFF1D1E33);
  static const Color primaryColor = Color(0xFF00D4FF);
  static const Color secondaryColor = Color(0xFF3A7BD5);
  static const Color accentColor = Color(0xFF00B4D8);
  static const Color gradient1 = Color(0xFF667eea);
  static const Color gradient2 = Color(0xFF764ba2);
  static const Color gradient3 = Color(0xFF1E3C72);
  static const Color textPrimary = Color(0xFFE1E1E1);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color borderColor = Color(0xFF2D2D2D);
  static const Color cardBackground = Color(0xFF1A1A2E);
  static const Color successColor = Color(0xFF00C896);
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color warningColor = Color(0xFFFECA57);
  static const Color whiteColor = Color(0xFFF8F8F8);
  static const Color greyColor = Color(0xFF8E8E8E);
  static const Color transparentColor = Colors.transparent;
  static const Color purpleColor = Color(0xFF6B4EFF);
  static const Color lightPurpleColor = Color(0xFFE0D9FF);

  // Gradients for cards and backgrounds
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradient1, gradient2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [cardBackground, Color(0xFF16213E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
