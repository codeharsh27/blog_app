import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

class AppTheme{
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
  borderSide: BorderSide(
  color: color,
  width: 1.5,
  ),
  borderRadius: BorderRadius.circular(12)
  );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    primaryColor: AppPallete.primaryColor,
    cardColor: AppPallete.cardBackground,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: AppPallete.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: AppPallete.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppPallete.textPrimary,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppPallete.textSecondary,
        fontSize: 14,
      ),
    ),
    chipTheme: const ChipThemeData(
    color: WidgetStatePropertyAll(AppPallete.surfaceColor),
    side: BorderSide.none,
    labelStyle: TextStyle(color: AppPallete.textPrimary),
  ),
  inputDecorationTheme: InputDecorationTheme(
  contentPadding: EdgeInsets.all(20),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.primaryColor),
      errorBorder: _border(AppPallete.errorColor),
      labelStyle: TextStyle(color: AppPallete.textSecondary),
      hintStyle: TextStyle(color: AppPallete.textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.primaryColor,
        foregroundColor: AppPallete.whiteColor,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppPallete.cardBackground,
      elevation: 4,
      shadowColor: AppPallete.primaryColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppPallete.transparentColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppPallete.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: AppPallete.textPrimary,
      ),
    ),
  );
}