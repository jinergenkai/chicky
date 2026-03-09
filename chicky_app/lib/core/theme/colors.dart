import 'package:flutter/material.dart';

class ChickyColors {
  ChickyColors._();

  // Primary warm yellow/orange palette
  static const Color primary = Color(0xFFF5A623);
  static const Color primaryLight = Color(0xFFFFCC66);
  static const Color primaryDark = Color(0xFFE08A00);

  // Secondary accent
  static const Color secondary = Color(0xFFFF6B35);
  static const Color secondaryLight = Color(0xFFFF9B6A);
  static const Color secondaryDark = Color(0xFFCC4A1A);

  // Background tones
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2A2A2A);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFFAAAAAA);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Vocabulary status colors
  static const Color vocabNew = Color(0xFF9E9E9E);       // gray — unseen
  static const Color vocabLearning = Color(0xFFFFB300);  // yellow — learning
  static const Color vocabKnown = Color(0xFF4CAF50);     // green — known
  static const Color vocabUnknown = Color(0xFFF44336);   // red — unknown

  // FSRS grade colors
  static const Color gradeAgain = Color(0xFFF44336);
  static const Color gradeHard = Color(0xFFFF9800);
  static const Color gradeGood = Color(0xFF4CAF50);
  static const Color gradeEasy = Color(0xFF2196F3);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Card colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1A000000);

  // Chat colors
  static const Color userBubble = Color(0xFFF5A623);
  static const Color assistantBubble = Color(0xFFF5F5F5);
  static const Color userBubbleText = Color(0xFFFFFFFF);
  static const Color assistantBubbleText = Color(0xFF1A1A1A);
}
