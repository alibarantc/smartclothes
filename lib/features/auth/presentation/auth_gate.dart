import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartclothes/core/navigation/main_navigation_screen.dart';
import 'package:smartclothes/core/widgets/smart_loading_indicator.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';
import 'package:smartclothes/features/welcome/presentation/welcome_screen.dart';

/// Gatekeeper widget that routes the user to [MainNavigationScreen] if authenticated
/// (or in Demo mode) or to [WelcomeScreen] if unauthenticated.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService.instance;

    return ValueListenableBuilder<bool>(
      valueListenable: authService.isDemoMode,
      builder: (context, isDemo, _) {
        if (isDemo) {
          return const MainNavigationScreen();
        }

        if (!authService.isFirebaseAvailable) {
          return const WelcomeScreen();
        }

        return StreamBuilder<User?>(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: SmartLoadingIndicator(
                    size: 40.0,
                    message: 'Oturum durumu kontrol ediliyor...',
                  ),
                ),
              );
            }

            if (snapshot.hasData && snapshot.data != null) {
              return const MainNavigationScreen();
            }

            return const WelcomeScreen();
          },
        );
      },
    );
  }
}
