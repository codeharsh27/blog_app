import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

class AppTheme{
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
  borderSide: BorderSide(
  color: color,
  width: 3,
  ),
  borderRadius: BorderRadius.circular(10)
  );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
  chipTheme: const ChipThemeData(
    color: WidgetStatePropertyAll(AppPallete.backgroundColor),
    side: BorderSide.none
  ),
  inputDecorationTheme: InputDecorationTheme(
  contentPadding: EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient1),
      errorBorder: _border(AppPallete.errorColor)
    )
  );
}