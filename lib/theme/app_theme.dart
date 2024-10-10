import 'package:flutter/material.dart';

class AppTheme {
  static const kPrimaryColorLight = Color(0xFFFFFFFF);
  static const kPrimaryColorDark = Color(0xFF222222);
  static const kSecondaryColor = Colors.red;
  static const kTextColorLight = Colors.black;
  static const kTextColorDark = Colors.white;

  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: kPrimaryColorLight,
      scaffoldBackgroundColor: kPrimaryColorLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: kPrimaryColorLight,
        foregroundColor: kTextColorLight,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kPrimaryColorLight,
        selectedItemColor: kSecondaryColor,
        unselectedItemColor: Colors.grey,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: kTextColorLight),
        bodyMedium: TextStyle(color: kTextColorLight),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200],
        hintStyle: TextStyle(color: Colors.grey[600]),
        prefixIconColor: Colors.grey[600],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: kPrimaryColorDark,
      scaffoldBackgroundColor: kPrimaryColorDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: kPrimaryColorDark,
        foregroundColor: kTextColorDark,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kPrimaryColorDark,
        selectedItemColor: kSecondaryColor,
        unselectedItemColor: Colors.grey,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: kTextColorDark),
        bodyMedium: TextStyle(color: kTextColorDark),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white24,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIconColor: Colors.white54,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}