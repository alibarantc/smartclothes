import 'package:flutter/material.dart';
import 'package:smartclothes/core/theme/app_colors.dart';

/// Central typography system for SmartClothes design system.
///
/// Features clean, modern styling with well-balanced hierarchy, line heights,
/// and letter spacings optimized for readability.
class AppTypography {
  AppTypography._();

  static const String? fontFamily = null; // Uses platform default clean sans-serif

  /// Builds a [TextTheme] for the given [brightness].
  static TextTheme textTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return TextTheme(
      // Display: Extra-large editorial/hero headlines
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 40.0,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.15,
        color: primaryColor,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32.0,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: primaryColor,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.25,
        color: primaryColor,
      ),

      // Headline: Section & page titles
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 26.0,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        height: 1.25,
        color: primaryColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.0,
        height: 1.3,
        color: primaryColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 19.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.0,
        height: 1.35,
        color: primaryColor,
      ),

      // Title: Card and component titles
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.0,
        height: 1.35,
        color: primaryColor,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
        color: primaryColor,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
        color: primaryColor,
      ),

      // Body: Content & description texts
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.5,
        color: primaryColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.5,
        color: secondaryColor,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
        height: 1.5,
        color: secondaryColor,
      ),

      // Label: Buttons, badges, and metadata tags
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        height: 1.3,
        color: primaryColor,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        height: 1.3,
        color: secondaryColor,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 10.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        height: 1.3,
        color: secondaryColor,
      ),
    );
  }
}
