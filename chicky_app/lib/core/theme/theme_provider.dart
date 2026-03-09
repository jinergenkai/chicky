import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/providers/auth_provider.dart';
import 'colors.dart';

// Represents the resolved dynamic theme context
class DynamicThemeState {
  final Color primaryColor;
  final ThemeMode themeMode;

  const DynamicThemeState({
    required this.primaryColor,
    required this.themeMode,
  });
}

final themeProvider = Provider<DynamicThemeState>((ref) {
  // Watch the current user's session
  final session = ref.watch(authStateProvider).valueOrNull?.session;
  
  if (session == null || session.user.userMetadata == null) {
    // Default fallback: Chicky Yellow Light Mode
    return const DynamicThemeState(
      primaryColor: ChickyColors.primary,
      themeMode: ThemeMode.light,
    );
  }

  final String? avatarUrl = session.user.userMetadata!['avatar_url'] as String?;

  switch (avatarUrl) {
    case 'chicky':
    case 'chicky.png':
      // Signature Yellow
      return const DynamicThemeState(
        primaryColor: Color(0xFFF5A623), // ChickyColors.primary
        themeMode: ThemeMode.light,
      );
    
    case 'foxy':
    case 'foxy.png':
      // Orange tone
      return const DynamicThemeState(
        primaryColor: Color(0xFFFF6B35), // ChickyColors.secondary
        themeMode: ThemeMode.light,
      );
      
    case 'black':
    case 'black.png':
      // Dark Theme (Black/Dark Grey)
      return const DynamicThemeState(
        primaryColor: Color(0xFF9E9E9E), // Greyish accent in dark mode
        themeMode: ThemeMode.dark, // Crucial: Force Dark Mode
      );
      
    case 'picky':
    case 'picky.png':
      // Pink tone
      return const DynamicThemeState(
        primaryColor: Color(0xFFE91E63), // Pink
        themeMode: ThemeMode.light,
      );
      
    case 'moxy':
    case 'moxy.png':
      // White/Black tone (monochrome/grayscale)
      return const DynamicThemeState(
        primaryColor: Color(0xFF424242), // Dark Grey
        themeMode: ThemeMode.light,
      );
      
    case 'cozy':
    case 'cozy.png':
      // Green tone
      return const DynamicThemeState(
        primaryColor: Color(0xFF4CAF50), // Green
        themeMode: ThemeMode.light,
      );
      
    case 'catchy':
    case 'catchy.png':
      // Brown tone
      return const DynamicThemeState(
        primaryColor: Color(0xFF795548), // Brown
        themeMode: ThemeMode.light,
      );
      
    case 'buxy':
    case 'buxy.png':
      // Grey tone
      return const DynamicThemeState(
        primaryColor: Color(0xFF607D8B), // Blue Grey
        themeMode: ThemeMode.light,
      );

    default:
      // Fallback
      return const DynamicThemeState(
        primaryColor: ChickyColors.primary,
        themeMode: ThemeMode.light,
      );
  }
});
