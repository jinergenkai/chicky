import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ChickyColors.primary,
        brightness: Brightness.light,
        primary: ChickyColors.primary,
        onPrimary: ChickyColors.textOnPrimary,
        secondary: ChickyColors.secondary,
        onSecondary: ChickyColors.textOnPrimary,
        surface: ChickyColors.surfaceLight,
        error: ChickyColors.error,
      ),
      scaffoldBackgroundColor: ChickyColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ChickyColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: ChickyColors.cardBackground,
        elevation: 2,
        shadowColor: ChickyColors.cardShadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ChickyColors.primary,
          foregroundColor: ChickyColors.textOnPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ChickyColors.primary,
          side: const BorderSide(color: ChickyColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ChickyColors.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: ChickyColors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ChickyColors.primaryLight.withValues(alpha: 0.2),
        selectedColor: ChickyColors.primary,
        labelStyle: const TextStyle(color: ChickyColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: ChickyColors.primary,
        unselectedItemColor: ChickyColors.textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: ChickyColors.primary,
        unselectedLabelColor: ChickyColors.textSecondary,
        indicatorColor: ChickyColors.primary,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ChickyColors.primary,
        foregroundColor: ChickyColors.textOnPrimary,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: ChickyColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ChickyColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ChickyColors.textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: ChickyColors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: ChickyColors.textPrimary),
        bodySmall: TextStyle(fontSize: 12, color: ChickyColors.textSecondary),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: ChickyColors.textPrimary,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ChickyColors.primary,
        brightness: Brightness.dark,
        primary: ChickyColors.primary,
        onPrimary: ChickyColors.textOnPrimary,
        secondary: ChickyColors.secondary,
        surface: ChickyColors.surfaceDark,
        error: ChickyColors.error,
      ),
      scaffoldBackgroundColor: ChickyColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2A2A2A),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF2A2A2A),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF2A2A2A),
        selectedItemColor: ChickyColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
