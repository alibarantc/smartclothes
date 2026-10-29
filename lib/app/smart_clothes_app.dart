import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/core/theme/app_theme.dart';
import 'package:smartclothes/features/welcome/presentation/welcome_screen.dart';

/// Root widget configuring application-wide theme, navigation, and localization.
class SmartClothesApp extends StatelessWidget {
  const SmartClothesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
    );
  }
}
