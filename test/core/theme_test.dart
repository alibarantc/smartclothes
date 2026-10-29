import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/core/theme/app_colors.dart';
import 'package:smartclothes/core/theme/app_theme.dart';

void main() {
  group('AppTheme & ColorScheme Tests', () {
    test('Light theme satisfies design requirements', () {
      final lightTheme = AppTheme.light;

      expect(lightTheme.useMaterial3, isTrue);
      expect(lightTheme.brightness, equals(Brightness.light));
      expect(lightTheme.scaffoldBackgroundColor, equals(AppColors.backgroundLight));
      expect(lightTheme.colorScheme.primary, equals(AppColors.primaryAccent));
      expect(lightTheme.colorScheme.surface, equals(AppColors.cardSurfaceLight));
      expect(lightTheme.colorScheme.onSurface, equals(AppColors.textPrimaryLight));
      expect(lightTheme.colorScheme.primaryContainer, equals(AppColors.secondarySurfaceLight));
    });

    test('Dark theme satisfies design requirements', () {
      final darkTheme = AppTheme.dark;

      expect(darkTheme.useMaterial3, isTrue);
      expect(darkTheme.brightness, equals(Brightness.dark));
      expect(darkTheme.scaffoldBackgroundColor, equals(AppColors.backgroundDark));
      expect(darkTheme.colorScheme.primary, equals(AppColors.primaryAccentDarkTheme));
      expect(darkTheme.colorScheme.surface, equals(AppColors.cardSurfaceDark));
      expect(darkTheme.colorScheme.onSurface, equals(AppColors.textPrimaryDark));
      expect(darkTheme.colorScheme.primaryContainer, equals(AppColors.secondarySurfaceDark));
    });
  });
}
