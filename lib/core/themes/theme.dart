/* Flutter Imports */
import 'package:flutter/material.dart';

/* Project Imports */
import 'package:prism/core/themes/palette.dart';

class CustomTheme {
  static final light = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Palette.background,
    primaryColor: Palette.primary,
    colorScheme: const ColorScheme.light(
      primary: Palette.primary,
      secondary: Palette.secondary,
      onPrimary: Palette.black,
      onSecondary: Palette.white,
    ),
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Palette.black,
          displayColor: Palette.black,
          fontFamily: 'Montserrat',
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Palette.primary,
    ),
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(
        Palette.background,
      ),
      side: BorderSide.none,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Palette.primary,
      indicatorColor: Palette.secondary,
    ),
    cardTheme: const CardTheme(
      color: Palette.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(10),
      labelStyle: const TextStyle(
        color: Palette.black,
        fontSize: 14,
      ),
      hintStyle: const TextStyle(
        fontSize: 14,
      ),
      focusedBorder: _border(Palette.black),
      enabledBorder: _border(),
      errorBorder: _border(Palette.error),
      focusedErrorBorder: _border(Palette.error),
      disabledBorder: _border(Palette.disabled),
      border: _border(),
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Palette.backgroundDark,
    primaryColor: Palette.primaryDark,
    colorScheme: const ColorScheme.dark(
      primary: Palette.primaryDark,
      secondary: Palette.secondaryDark,
      onPrimary: Palette.white,
      onSecondary: Palette.white,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Palette.white,
          displayColor: Palette.white,
          fontFamily: 'Montserrat',
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Palette.primaryDark,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: Palette.backgroundDark,
      side: BorderSide.none,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Palette.primaryDark,
      indicatorColor: Palette.secondaryDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(10),
      labelStyle: const TextStyle(
        color: Palette.white,
        fontFamily: 'Montserrat',
        fontSize: 14,
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
      ),
      focusedBorder: _border(Palette.white),
      enabledBorder: _border(),
      errorBorder: _border(Palette.error),
      focusedErrorBorder: _border(Palette.error),
      disabledBorder: _border(Palette.disabled),
      border: _border(),
    ),
  );

  static _border([Color color = Palette.border]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(5),
      );
}
