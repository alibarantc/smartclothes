import 'package:flutter/material.dart';

/// Central color definitions for SmartClothes design system.
///
/// Palette specification:
/// - Background: `#F8F7F3`
/// - Primary text: `#252A27`
/// - Primary accent: `#829580`
/// - Secondary surface: `#E8E3D9`
/// - Card surface: `#FFFFFF`
class AppColors {
  AppColors._();

  // --- Light Theme Colors ---
  static const Color backgroundLight = Color(0xFFF8F7F3);
  static const Color textPrimaryLight = Color(0xFF252A27);
  static const Color textSecondaryLight = Color(0xFF5E6560);
  static const Color textMutedLight = Color(0xFF8A938C);

  static const Color primaryAccent = Color(0xFF829580);
  static const Color primaryAccentDark = Color(0xFF677965);
  static const Color primaryAccentLight = Color(0xFFA1B39F);

  static const Color secondarySurfaceLight = Color(0xFFE8E3D9);
  static const Color cardSurfaceLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFDDD7CC);
  static const Color dividerLight = Color(0xFFE5E0D5);

  // --- Dark Theme Colors ---
  static const Color backgroundDark = Color(0xFF161917);
  static const Color textPrimaryDark = Color(0xFFEDECE8);
  static const Color textSecondaryDark = Color(0xFFA2A9A3);
  static const Color textMutedDark = Color(0xFF707771);

  static const Color primaryAccentDarkTheme = Color(0xFF98AB96);

  static const Color secondarySurfaceDark = Color(0xFF232825);
  static const Color cardSurfaceDark = Color(0xFF1D221F);
  static const Color borderDark = Color(0xFF353C37);
  static const Color dividerDark = Color(0xFF2C322E);

  // --- Feedback & State Colors ---
  static const Color success = Color(0xFF4E7D59);
  static const Color successContainer = Color(0xFFD4E7D7);
  static const Color warning = Color(0xFFC7893B);
  static const Color warningContainer = Color(0xFFFBE8D0);
  static const Color error = Color(0xFFBA3838);
  static const Color errorContainer = Color(0xFFF9DADA);

  // --- Transparent & Neutral ---
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}
