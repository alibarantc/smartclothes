import 'package:flutter/material.dart';

/// Spacing constants used consistently across the application.
class AppSpacing {
  AppSpacing._();

  /// 4.0
  static const double xs = 4.0;

  /// 8.0
  static const double sm = 8.0;

  /// 12.0
  static const double mdSm = 12.0;

  /// 16.0
  static const double md = 16.0;

  /// 20.0
  static const double mdLg = 20.0;

  /// 24.0
  static const double lg = 24.0;

  /// 32.0
  static const double xl = 32.0;

  /// 40.0
  static const double xxl = 40.0;

  /// 48.0
  static const double xxxl = 48.0;

  /// 64.0
  static const double huge = 64.0;
}

/// Border radius constants used across the application.
class AppRadius {
  AppRadius._();

  /// 4.0
  static const double xs = 4.0;

  /// 8.0
  static const double sm = 8.0;

  /// 12.0
  static const double md = 12.0;

  /// 16.0
  static const double lg = 16.0;

  /// 20.0
  static const double xl = 20.0;

  /// 28.0
  static const double xxl = 28.0;

  /// 999.0 (Pill / Circular)
  static const double circular = 999.0;

  // Pre-built BorderRadius instances for efficiency
  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius roundedLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius roundedXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius roundedCircular = BorderRadius.all(Radius.circular(circular));
}

/// Global application constants and strings.
class AppConstants {
  AppConstants._();

  static const String appName = 'SmartClothes';
  static const String appSlogan = 'Dolabını tanır, tarzını öğrenir.';
  static const String appDescription =
      'Sahip olduğun parçalarla en uyumlu kombinleri keşfet, stiline zahmetsizce değer kat.';

  /// Animation durations
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
}
