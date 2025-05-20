import 'package:flutter/material.dart';

class AppThemes {
  // Colors for light theme
  static const Color _lightPrimaryColor = Color(0xFF2196F3);
  static const Color _lightSecondaryColor = Color(0xFF03A9F4);
  static const Color _lightBackgroundColor = Colors.white;
  static const Color _lightSurfaceColor = Colors.white;
  static const Color _lightOnPrimaryColor = Colors.white;
  static const Color _lightTextColorPrimary = Color(0xFF303030);
  static const Color _lightTextColorSecondary = Color(0xFF606060);
  static const Color _lightErrorColor = Color(0xFFB00020);

  // Colors for dark theme
  static const Color _darkPrimaryColor = Color(0xFF2196F3);
  static const Color _darkSecondaryColor = Color(0xFF0288D1);
  static const Color _darkBackgroundColor = Color(0xFF121212);
  static const Color _darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color _darkOnPrimaryColor = Colors.white;
  static const Color _darkTextColorPrimary = Colors.white;
  static const Color _darkTextColorSecondary = Color(0xFFB3B3B3);
  static const Color _darkErrorColor = Color(0xFFCF6679);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _lightPrimaryColor,
    primarySwatch: Colors.blue,
    colorScheme: const ColorScheme.light(
      primary: _lightPrimaryColor,
      secondary: _lightSecondaryColor,
      background: _lightBackgroundColor,
      surface: _lightSurfaceColor,
      onPrimary: _lightOnPrimaryColor,
      error: _lightErrorColor,
    ),
    scaffoldBackgroundColor: _lightBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: _lightPrimaryColor,
      centerTitle: true,
    ),
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: _lightTextColorPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: _lightTextColorPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: _lightTextColorSecondary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: _lightTextColorSecondary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimaryColor,
        foregroundColor: _lightOnPrimaryColor,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: _lightPrimaryColor,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.all(16),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _lightSurfaceColor,
      selectedItemColor: _lightPrimaryColor,
      unselectedItemColor: _lightTextColorSecondary,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: _lightSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    cardTheme: CardTheme(
      color: _lightSurfaceColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _darkPrimaryColor,
    colorScheme: const ColorScheme.dark(
      primary: _darkPrimaryColor,
      secondary: _darkSecondaryColor,
      background: _darkBackgroundColor,
      surface: _darkSurfaceColor,
      onPrimary: _darkOnPrimaryColor,
      error: _darkErrorColor,
    ),
    scaffoldBackgroundColor: _darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: _darkPrimaryColor,
      centerTitle: true,
    ),
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: _darkTextColorPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: _darkTextColorPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: _darkTextColorSecondary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: _darkTextColorSecondary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimaryColor,
        foregroundColor: _darkOnPrimaryColor,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: _darkPrimaryColor,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.all(16),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _darkSurfaceColor,
      selectedItemColor: _darkPrimaryColor,
      unselectedItemColor: _darkTextColorSecondary,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: _darkSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    cardTheme: CardTheme(
      color: _darkSurfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF424242),
      thickness: 1,
    ),
  );
}
